const ManageResources = artifacts.require("ManageResources");

module.exports = function(deployer) {
  deployer.deploy(ManageResources);
};