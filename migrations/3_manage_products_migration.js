const ManageResources = artifacts.require("ManageResources");
const ManageProducts = artifacts.require("ManageProducts");
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

const contractName = 'manage_resources_migration';
const nestedContractName = 'manage_products_migration';

module.exports = function(deployer) {
  connection.connect();
  deployer.deploy(ManageResources)
    .then(function() {
      connection.query('select * from contract where name=?',[contractName], function (error, results) {
        if (error) throw error;
        if (results.length === 0) {
          const contract = {
            name: contractName,
            address: ManageResources.address,
            abi: JSON.stringify(ManageResources.abi)
          }
          connection.query('insert into contract set ?', contract, function (error, results) {
            if (error) throw error;
            if (results.insertId > 0) {
              console.log('Contract info for ', contractName, ' was added to ', results.insertId);
            }
          })
        } else {
          connection.query(
            'update contract set address = ?, abi = ?, updatedAt = CURRENT_TIMESTAMP where name = ?',
            [ManageResources.address, JSON.stringify(ManageResources.abi), contractName], 
            function (error, results) {
              if (error) throw error;
              if (results.changedRows > 0) {
                console.log('Contract info for ', contractName, ' was updated.');
              }
            }
          )
        }
      });
      return deployer.deploy(ManageProducts, ManageResources.address).then(function() {
        connection.query('select * from contract where name=?',[nestedContractName], function (error, results) {
          if (error) throw error;
          if (results.length === 0) {
            const contract = {
              name: nestedContractName,
              address: ManageProducts.address,
              abi: JSON.stringify(ManageProducts.abi)
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
              [ManageProducts.address, JSON.stringify(ManageProducts.abi), nestedContractName], 
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
    });
};
