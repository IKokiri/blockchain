pragma solidity ^0.5.0;

contract Ownable {
    address public owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    //O construtor Ownable define o `proprietário` original do contrato para o remetente conta.
    constructor() public {
        owner = msg.sender;
    }

    //Lança se chamado por qualquer conta diferente do proprietário.
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // Permite que o atual proprietário transfira o controle do contrato para um novo proprietário.
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}


contract Marketplace is Ownable {
    string public name;
    uint256 public productCount = 0;
    mapping(uint256 => Product) public products;

    struct Product {
        uint256 id;
        string name;
        uint256 price;
        address payable owner;
        bool purchased;
    }

    event ProductCreated(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    constructor() public {
        name = "Dapp University Marketplace";
    }

    function createProduct(string memory _name, uint256 _price) public {
        // Requer um nome
        require(bytes(_name).length > 0, "Entre com um nome válido");

        // Exigir um preço válido
        require(_price > 0, "Entre com um preço válido");

        // Aumentar a contagem do produto
        productCount++;
        // Crie o produto
        products[productCount] = Product(
            productCount,
            _name,
            _price,
            msg.sender,
            false
        );
        // Aciona um evento
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint256 _id) public payable {
        // Pegue o produto e faça uma cópia dele
        Product memory _product = products[_id];
        // Buscar o proprietário
        address payable _seller = _product.owner;
        // Certifique-se de que o produto tem uma id válida

        address payable _ownerPayable = address(uint160(owner));
        require(
            _product.id > 0 && _product.id <= productCount,
            "Entre com uma id válida"
        );
        // Exigir que haja Ether suficiente na transação
        require(msg.value >= _product.price, "Por favor, entre com um valor válido");
        // Exigir que o comprador não seja o vendedor
        require(msg.sender != _seller, "Você não pode comprar seu próprio produto");
        // Transfira a propriedade para o comprador
        _product.owner = msg.sender;
        // Marcar como comprado
        _product.purchased = true;
        // Atualize o produto
        products[_id] = _product;

        uint percent = msg.value / 100 * 5;
        uint percent2 = msg.value / 100 * 95;

        // Pague ao vendedor enviando éter
        address(_seller).transfer(msg.value - percent);
        // Pague ao vendedor enviando éter
        address(_ownerPayable).transfer(msg.value - percent2);
        // Aciona um evento
        emit ProductPurchased(
            productCount,
            _product.name,
            _product.price,
            msg.sender,
            true
        );
    }
}
