const ArrayUtils = artifacts.require("ArrayUtils");
const ManageResources = artifacts.require("ManageResources");

module.exports = function(deployer) {
  deployer.deploy(ArrayUtils);
  deployer.link(ArrayUtils, ManageResources);
  deployer.deploy(ManageResources);
};