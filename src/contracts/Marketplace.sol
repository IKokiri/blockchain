
pragma solidity ^0.5.0;

contract Marketplace {
  string public name;
  uint public productCount=0;
  mapping(uint => Product) public products;
  address payable ownerContract;

struct Product {
  uint id;
  string name;
  uint price;
  address payable owner;
  bool sale;
}

event ProductCreated (
  uint id,
  string name,
  uint price,
  address payable owner,
  bool sale
);

event ProductPurchased (
  uint id,
  string name,
  uint price,
  address payable owner,
  bool sale
);

event ProductChanged (
  uint id,
  string name,
  uint price,
  address payable owner,
  bool sale
);


  constructor() public {
    name = "Dapp University Marketplace";
    ownerContract = msg.sender;
  }

  function createProduct(string memory _name, uint _price, bool _sale) public {
    //Require a name
    require(bytes(_name).length > 0, "Enter a valid name");
    //Requiere a valid price
    require(_price > 0, "Enter a valid price");
    //Increment product count
    productCount++;
    //Create the product
    products[productCount] = Product(productCount, _name, _price, msg.sender, _sale);
    //Trigger an event
    emit ProductCreated(productCount, _name, _price, msg.sender, _sale);
  }

  function markForSale(uint _id, bool _sale) public {
       //Fetch the product and make a copy of it
    Product memory _product = products[_id];
      //Require that the buyer is not the seller
    require(msg.sender == _product.owner, "Only the contract owner can marked sale");
      //Mark as purchased
    _product.sale = _sale;
      //Update the product
    products[_id] = _product;
    emit ProductChanged(productCount, _product.name, _product.price,_product.owner, _product.sale);
  }

   function changePrice(uint _id, uint _price) public {
       //Fetch the product and make a copy of it
    Product memory _product = products[_id];
      //Require that the buyer is not the seller
    require(msg.sender == _product.owner, "Only the contract owner can change its value");
      //Mark as purchased
    _product.price = _price;
      //Update the product
    products[_id] = _product;
    emit ProductChanged(productCount, _product.name, _product.price,_product.owner, _product.sale);
  }

  function purchaseProduct(uint _id) public payable {
    //Fetch the product and make a copy of it
    Product memory _product = products[_id];
    //Fetch the owner
    address payable _seller = _product.owner;
    //Make sure the product has valid id
    require(_product.id > 0 && _product.id <= productCount, "Enter valid id");
    //Require that there is enough Ether in the transaction
    require(msg.value >= _product.price,"Transfer the correct amount");
    //Require that the buyer is not the seller
    require(msg.sender != _seller, "Buyer cannot be seller");
      //Require that Product is marked for sale
    require(_product.sale == true, "Product not marked for sale");
    //Transfer ownership to the buyer
    _product.owner = msg.sender;
    //Update the product
    products[_id] = _product;
    //Pay the seller by sending them Ether
    address(_seller).transfer(msg.value);
    //Trigger an event
    emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, false);
  }
}

