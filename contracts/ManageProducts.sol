pragma solidity >=0.4.21 <0.6.0;
pragma experimental ABIEncoderV2;
import "./ManageResources.sol";
import "./Owned.sol";

contract ManageProducts is Owned {
  struct ProductionDetail {
    string message;
    uint64 additionalId;
    uint date;
  }

  enum StepStatus {Valid, Invalid, Indefinite}
  enum ProductState {Producing, Finished, InQueue}

  struct ProductionStep {
    uint64 identifier;
    StepStatus status;
    ProductionDetail[] details;
  }

  struct Product {
    uint64 identifier;
    bool valid;
    ProductState state;
    uint64[] stepIdList;
    mapping(uint64 => ProductionStep) steps;
  }

  mapping(uint64 => Product) private productsState;
  ManageResources resourcesInstance;

  event ProductAdded(uint64 identifier, bool valid, ProductState state);

  constructor(address resourceAddress) public {
    resourcesInstance = ManageResources(resourceAddress);
  }

  modifier checkUser() {
    require(resourcesInstance.chekUserExistance(msg.sender), "User doesn't exists!");
    require(resourcesInstance.chekUserIsActive(msg.sender), "User is not active!");
    _;
  }

  function addProduct(uint64 productId, uint64[] memory stepIds, uint timestamp) public checkUser {
    productsState[productId].identifier = productId;
    productsState[productId].valid = false;
    productsState[productId].state = ProductState.InQueue;
    for (uint64 i = 0; i < stepIds.length; i++) {
      productsState[productId].steps[stepIds[i]].identifier = stepIds[i];
      productsState[productId].steps[stepIds[i]].status = StepStatus.Indefinite;
      productsState[productId].steps[stepIds[i]].details.push(ProductionDetail("Step created", 0, timestamp));
      productsState[productId].stepIdList.push(stepIds[i]);
    }
    emit ProductAdded(productId, false, ProductState.InQueue);
  }

  function getProduct(uint64 productId) public view checkUser returns(uint64 id, bool valid, ProductState state) {
    return (
      productsState[productId].identifier,
      productsState[productId].valid,
      productsState[productId].state
    );
  }

  function getStep(
    uint64 productId,
    uint64 stepId
  ) public view checkUser returns(uint64 id, StepStatus status, string[] memory messages, uint64[] memory additionalId, uint[] memory dates) {
    string[] memory tempMessages = new string[](productsState[productId].steps[stepId].details.length);
    uint64[] memory tempIds = new uint64[](productsState[productId].steps[stepId].details.length);
    uint[] memory tempDates = new uint[](productsState[productId].steps[stepId].details.length);
    for (uint i = 0; i < productsState[productId].steps[stepId].details.length; i++) {
      tempMessages[i] = productsState[productId].steps[stepId].details[i].message;
      tempDates[i] = productsState[productId].steps[stepId].details[i].date;
      if (productsState[productId].steps[stepId].details[i].additionalId > 0) {
        tempIds[i] = productsState[productId].steps[stepId].details[i].additionalId;
      } else {
        tempIds[i] = 0;
      }
    }
    return (
      productsState[productId].steps[stepId].identifier,
      productsState[productId].steps[stepId].status,
      tempMessages,
      tempIds,
      tempDates
    );
  }

  function startProducing(uint64 productId) public checkUser {
    productsState[productId].state = ProductState.Producing;
  }

  function endProducing(uint64 productId) public checkUser {
    productsState[productId].state = ProductState.Finished;
  }

  function updateStepStartStatus(uint64 productId, uint64 stepId) public checkUser {
    productsState[productId].steps[stepId].status = StepStatus.Valid;
  }

  function addStepSimpleDetails(
    uint64 productId,
    uint64 stepId,
    string memory message,
    uint timestamp
  ) public checkUser {
    productsState[productId].steps[stepId].details.push(ProductionDetail(message, 0, timestamp));
  }

  function addStepDetails(
    uint64 productId,
    uint64 stepId,
    string memory message,
    uint64 additionalId,
    uint timestamp
  ) public checkUser {
    productsState[productId].steps[stepId].details.push(ProductionDetail(message, additionalId, timestamp));
    if (!resourcesInstance.chekOrgExistance(additionalId) || !resourcesInstance.chekOrgIsActive(additionalId)) {
      productsState[productId].steps[stepId].status = StepStatus.Invalid;
    }
    updateProductStatus(productId);
  }

  function updateProductStatus(uint64 productId) private {
    bool valid = true;
    for(uint64 i = 0; i < productsState[productId].stepIdList.length; i++) {
      if (productsState[productId].steps[productsState[productId].stepIdList[i]].status == StepStatus.Invalid) {
        valid = false;
      }
    }
    if (!valid) {
      productsState[productId].valid = false;
    }
  }
}