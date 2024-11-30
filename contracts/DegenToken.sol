// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable {
    // Constructor to initialize the token
        struct Item {
        string name;
        uint256 price; // Price in tokens
    }

    // Mapping for store items
    mapping(uint256 => Item) public storeItems;
    uint256 public nextItemId;

    constructor() ERC20("Degen", "DGN") {
    // Items
        addItem("[Item 0] - Potion (Magenta)", 3); // Item ID 0
        addItem("[Item 1] - Weapon (Kingslayer)", 6); // Item ID 1
        addItem("[Item 2] - Armor (Knight of Knights)", 10); // Item ID 2
    }

    //Mint new tokens to a specified address. Only the owner can call this.
    function mint(address to, uint256 amount) public onlyOwner {
        require(amount >= 1, "Minted DGNs must be at least 1 or higher.");
        _mint(to, amount);
    }

    //Overrides the decimals function to set the number of decimals to 0.
    function decimals() public pure override returns (uint8) {
        return 0;
    }

    //Checks the token balance of a specified address.
    function balanceOfAccount(address account) external view returns (uint256) {
        return balanceOf(account);
    }

    //Transfer tokens to another address.
    function transferTx(address _otherend, uint256 _val) external {
        require(balanceOf(msg.sender) >= _val, "Insufficient DGN.");
        approve(msg.sender, _val);
        transferFrom(msg.sender, _otherend, _val);
    }

    //Burn a specified number of tokens from the caller's account.
    function burnTx(uint256 _val) external {
        require(balanceOf(msg.sender) >= _val, "Insufficient DGN.");
         _burn(msg.sender, _val);
    }

    //Add an item to the store (only owner can add items)
    function addItem(string memory name, uint256 price) internal {
        require(price > 0, "Price must be greater than zero");
        storeItems[nextItemId] = Item(name, price);
        nextItemId++;
    }

    //Shows the items available for shop.
    function getAllItems() public view returns (string[] memory, uint256[] memory) {
        string[] memory names = new string[](nextItemId);
        uint256[] memory prices = new uint256[](nextItemId);

        for (uint256 i = 0; i < nextItemId; i++) {
         names[i] = storeItems[i].name;
         prices[i] = storeItems[i].price;
    }

    return (names, prices);
}
    //Redeem tokens for an item
    function redeem(uint256 itemId) public {
        Item memory item = storeItems[itemId];
        require(bytes(item.name).length > 0, "Item does not exist!");
        require(balanceOf(msg.sender) >= item.price, "Insufficient DGN");

        // Burn tokens as payment
        _burn(msg.sender, item.price);

        //Logic for granting the item goes here (e.g., emitting an event)
        emit ItemRedeemed(msg.sender, itemId, item.name);
    }

    // Event for item redemption
    event ItemRedeemed(address indexed redeemer, uint256 itemId, string itemName);

}
