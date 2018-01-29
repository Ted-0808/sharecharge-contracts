pragma solidity ^0.4.18;

import "./ChargingStationStorage.sol";
import "./ChargingSessions.sol";

contract ChargingStation {

    ChargingStationStorage private stationStorage;
    ChargingSessions private chargingSessions;

    event StartRequested(bytes32 indexed connectorId, address controller);
    event StartConfirmed(bytes32 indexed connectorId);

    event StopRequested(bytes32 indexed connectorId, address controller);
    event StopConfirmed(bytes32 indexed connectorId);

    event Error(bytes32 indexed connectorId, string error);
    
    function ChargingStation(address stationStorageAddress, address chargingSessionAddress) public {
        stationStorage = ChargingStationStorage(stationStorageAddress);
        chargingSessions = ChargingSessions(chargingSessionAddress);
    }

    function requestStart(bytes32 connectorId) public {
        require(stationStorage.isAvailable(connectorId) == true);
        require(stationStorage.isVerified(connectorId) == true);
        chargingSessions.set(connectorId, msg.sender);
        StartRequested(connectorId, msg.sender);
    }

    function confirmStart(bytes32 connectorId, address controller) public {
        require(stationStorage.getOwner(connectorId) == msg.sender);
        require(chargingSessions.get(connectorId) == controller);
        stationStorage.setAvailability(connectorId, false);
        StartConfirmed(connectorId);
    }

    function requestStop(bytes32 connectorId) public {
        require(chargingSessions.get(connectorId) == msg.sender);
        StopRequested(connectorId, msg.sender);

    }

    function confirmStop(bytes32 connectorId) public {
        require(stationStorage.getOwner(connectorId) == msg.sender);
        chargingSessions.set(connectorId, 0);
        stationStorage.setAvailability(connectorId, true);
        StopConfirmed(connectorId);
    }

    function connectorError(bytes32 connectorId, string error) public {
        Error(connectorId, error);

    }

}
