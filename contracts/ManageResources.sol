pragma solidity >=0.4.21 <0.6.0;
import './Owned.sol';
import './ArrayUtils.sol';

contract ManageResources is Owned {
    struct User {
        address addr;
        bool active;
    }

    struct Entity{
        uint64 id;
        bool active;
    }

    User[] private AvailableUsers;
    Entity[] private AvailableProducts;
    Entity[] private AvailableOrganizations;

    event UserAdded(address user);
    event UserExists(address user);
    event UserDoesNotExist(address user);
    event UserEnabled(address user);
    event UserDisabled(address user);
    event ProductAdded(uint64 productId);
    event ProductExists(uint64 productId);
    event ProductDoesNotExist(uint64 productId);
    event ProductEnabled(uint64 productId);
    event ProductDisabled(uint64 productId);
    event OrganizationAdded(uint64 organizationId);
    event OrganizationExists(uint64 organizationId);
    event OrganizationDoesNotExist(uint64 productId);
    event OrganizationEnabled(uint64 organizationId);
    event OrganizationDisabled(uint64 organizationId);

    function chekUserExistance(address user) private view onlyOwner returns (bool) {
        for (uint64 index = 0; index < AvailableUsers.length; index++) {
            if (user == AvailableUsers[index].addr) {
                return true;
            }
        }
        return false;
    }

    function chekProductsExistance(uint64 id) private view onlyOwner returns (bool) {
        for (uint64 index = 0; index < AvailableProducts.length; index++) {
            if (id == AvailableProducts[index].id) {
                return true;
            }
        }
        return false;
    }

    function chekOrgExistance(uint64 id) private view onlyOwner returns (bool) {
        for (uint64 index = 0; index < AvailableOrganizations.length; index++) {
            if (id == AvailableOrganizations[index].id) {
                return true;
            }
        }
        return false;
    }

    function addUser(address user) public onlyOwner {
        if (!chekUserExistance(user)) {
            AvailableUsers.push(User(user, true));
            emit UserAdded(user);
        } else {
            emit UserExists(user);
        }
    }

    function enableUser(address user) public onlyOwner {
        for (uint64 index = 0; index < AvailableUsers.length; index++) {
            if (user == AvailableUsers[index].addr) {
                AvailableUsers[index].active = true;
                emit UserEnabled(user);
            }
        }
        emit UserDoesNotExist(user);
    }

    function disableUser(address user) public onlyOwner {
        for (uint64 index = 0; index < AvailableUsers.length; index++) {
            if (user == AvailableUsers[index].addr) {
                AvailableUsers[index].active = false;
                emit UserDisabled(user);
            }
        }
         emit UserDoesNotExist(user);
    }

    function addProduct(uint64 productId) public onlyOwner {
        if (!chekProductsExistance(productId)) {
            AvailableProducts.push(Entity(productId, true));
            emit ProductAdded(productId);
        } else {
            emit ProductExists(productId);
        }
    }

    function enableProduct(uint64 productId) public onlyOwner {
        for (uint64 index = 0; index < AvailableProducts.length; index++) {
            if (productId == AvailableProducts[index].id) {
                AvailableProducts[index].active = true;
                emit ProductEnabled(productId);
            }
        }
        emit ProductDoesNotExist(productId);
    }

    function disableProduct(uint64 productId) public onlyOwner {
        for (uint64 index = 0; index < AvailableProducts.length; index++) {
            if (productId == AvailableProducts[index].id) {
                AvailableProducts[index].active = false;
                emit ProductDisabled(productId);
            }
        }
        emit ProductDoesNotExist(productId);
    }

    function addOrganization(uint64 organizationId) public onlyOwner {
        if (!chekOrgExistance(organizationId)) {
            AvailableOrganizations.push(Entity(organizationId, true));
            emit OrganizationAdded(organizationId);
        } else {
            emit OrganizationExists(organizationId);
        }
    }

    function enableOrganization(uint64 organizationId) public onlyOwner {
        for (uint64 index = 0; index < AvailableOrganizations.length; index++) {
            if (organizationId == AvailableOrganizations[index].id) {
                AvailableOrganizations[index].active = true;
                emit OrganizationEnabled(organizationId);
            }
        }
        emit OrganizationDoesNotExist(organizationId);
    }

    function disableOrganization(uint64 organizationId) public onlyOwner {
        for (uint64 index = 0; index < AvailableOrganizations.length; index++) {
            if (organizationId == AvailableOrganizations[index].id) {
                AvailableOrganizations[index].active = false;
                emit OrganizationDisabled(organizationId);
            }
        }
        emit OrganizationDoesNotExist(organizationId);
    }
}