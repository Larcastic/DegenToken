# My Project Entry: Degen Token (ERC-20): Unlocking the Future of Gaming
A unique ERC-20 token named 'Degen/DGN' for Degen Gaming. 

## Description
Create a special and unique token named 'Degen/DGN' for Degen Gaming that they can use for their future gaming projects inside the blockchain platform.

## Getting Started
Our task is to create an ERC-20 token via Solidity, be able to simulate and run it with an IDE, and show the made transactions via a platform with also a use of a wallet.
For this Project, we used:
- Metamask (wallet)
- Remix (IDE)
- OpenZeppelin Wizard (ERC-20 builder)
- Avalanche Snowtrace Testnet (platform)

### Smart Contract Details and Execution
*Boot up Remix and set 'Injected Provider - Metamask' as environment and deploy. Copy the address of the smart contract and paste it on Avalanche Snowtrace to show it on the platform and display the recorded transactions.*

- Firstly created the properties and the mapping of our items on our in-game shop, then inside the constructor we declared all the items we want to store inside the in-game shop.
```
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
```
- We made a minting function modified with a require() statement to enable the owner to input a minumum amount of 1 token to be minted.
```
    function mint(address to, uint256 amount) public onlyOwner {
        require(amount >= 1, "Minted DGNs must be at least 1 or higher.");
        _mint(to, amount);
    }
```
- The decimal() function overrides the decimals function to set the number of decimals to 0.
```
    function decimals() public pure override returns (uint8) {
        return 0;
    }
```
- The balanceOfAccount() function checks the token balance of a specified address.
```
    function balanceOfAccount(address account) external view returns (uint256) {
        return balanceOf(account);
    }
```
- The transferTx() function enables the transferring of tokens to another user.
```
  function transferTx(address _otherend, uint256 _val) external {
        require(balanceOf(msg.sender) >= _val, "Insufficient DGN.");
        approve(msg.sender, _val);
        transferFrom(msg.sender, _otherend, _val);
    }
```
- The addItem() function adds an item to the shop (only the owner can add items).
```
    function addItem(string memory name, uint256 price) internal {
        require(price > 0, "Price must be greater than zero");
        storeItems[nextItemId] = Item(name, price);
        nextItemId++;
    }
```
- The getAllItems() function shows all the available items on the shop.
```
    function getAllItems() public view returns (string[] memory, uint256[] memory) {
        string[] memory names = new string[](nextItemId);
        uint256[] memory prices = new uint256[](nextItemId);

        for (uint256 i = 0; i < nextItemId; i++) {
         names[i] = storeItems[i].name;
         prices[i] = storeItems[i].price;
    }

    return (names, prices);
    }
```
- The redeem() function redeems an item from our in-game shop. To redeem an item at the shop, the user must only call the specified Item ID of the item they wish to redeem.
```
   function redeem(uint256 itemId) public {
        Item memory item = storeItems[itemId];
        require(bytes(item.name).length > 0, "Item does not exist!");
        require(balanceOf(msg.sender) >= item.price, "Insufficient DGN");

        // Burn tokens as payment
        _burn(msg.sender, item.price);

        //Logic for granting the item goes here (e.g., emitting an event)
        emit ItemRedeemed(msg.sender, itemId, item.name);
    }

  //Event for item redemption
    event ItemRedeemed(address indexed redeemer, uint256 itemId, string itemName);
```

## Authors
Lars James Manansala (larsjamesmanansala@gmail.com)
