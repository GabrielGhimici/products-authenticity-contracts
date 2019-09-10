const Owned = artifacts.require("Owned");
const mysql      = require('mysql');
const dotenv     = require('dotenv');

dotenv.config({ path: '../.env' });

const connection = mysql.createConnection({
  host     : process.env.DB_HOST,
  port     : process.env.DB_PORT,
  user     : process.env.DB_USER,
  password : process.env.DB_PASS,
  database : process.env.DB_DATABASE
});

const contractName = 'owned_migration';

module.exports = function(deployer) {
  deployer.deploy(Owned).then(function() {
    connection.connect();
    connection.query('select * from contract where name=?',[contractName], function (error, results) {
      if (error) throw error;
      if (results.length === 0) {
        const contract = {
          name: contractName,
          address: Owned.address,
          abi: JSON.stringify(Owned.abi)
        }
        connection.query('insert into contract set ?', contract, function (error, results) {
          if (error) throw error;
          if (results.insertId > 0) {
            console.log('Contract info for ', contractName, ' was added to ', results.insertId);
          }
          connection.end();
        })
      } else {
        connection.query(
          'update contract set address = ?, abi = ?, updatedAt = CURRENT_TIMESTAMP where name = ?',
          [Owned.address, JSON.stringify(Owned.abi), contractName], 
          function (error, results) {
            if (error) throw error;
            if (results.changedRows > 0) {
              console.log('Contract info for ', contractName, ' was updated.');
            }
            connection.end();
          }
        )
      }
    });
  });
};
