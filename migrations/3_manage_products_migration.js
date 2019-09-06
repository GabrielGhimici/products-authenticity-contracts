const ManageResources = artifacts.require("ManageResources");
const ManageProducts = artifacts.require("ManageProducts");

module.exports = function(deployer) {
  deployer.deploy(ManageResources)
    .then(function() {
      return deployer.deploy(ManageProducts, ManageResources.address);
    });
};