pragma solidity ^0.4.18;

import "./Restricted.sol";

contract StationStorage is Restricted {

    struct Connector {
        bytes32 client;
        address owner;
        string ownerName;
        string lat;
        string lng;
        uint16 price;
        uint8 priceModel;
        uint8 plugType;
        string openingHours;
        bool isAvailable;
        address session;
    }

    mapping(bytes32 => Connector) public connectors;
    bytes32[] public ids;

    event Registered(bytes32 indexed id);

    // SETTERS

    function register(bytes32 id, bytes32 client, address owner, string ownerName, string lat, string lng, uint16 price, uint8 priceModel, uint8 plugType, string openingHours, bool isAvailable) public restricted {
        connectors[id] = Connector(client, owner, ownerName, lat, lng, price, priceModel, plugType, openingHours, isAvailable, 0);
        ids.push(id);
        Registered(id);
    }

    function setAvailability(bytes32 id, bool isAvailable) public restricted {
        connectors[id].isAvailable = isAvailable;
    }

    function setSession(bytes32 id, address session) public restricted {
        connectors[id].session = session;
    }

    // GETTERS

    function isAvailable(bytes32 id) view public returns (bool) {
        return connectors[id].isAvailable;
    }

    function getOwner(bytes32 id) view public returns (address) {
        return connectors[id].owner;
    }

    function getClient(bytes32 id) view public returns (bytes32) {
        return connectors[id].client;
    }

    function getSession(bytes32 id) view public returns (address) {
        return connectors[id].session;
    }

}
