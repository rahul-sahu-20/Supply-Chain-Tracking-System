// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SupplyChain
 * @dev Implements a supply chain tracking system that allows tracking products from manufacturer to consumer
 */
contract SupplyChain {
    enum ProductStatus { Created, InTransit, Delivered }
    
    struct Product {
        uint256 id;
        string name;
        string description;
        address manufacturer;
        address currentOwner;
        ProductStatus status;
        uint256 timestamp;
        string location;
    }
    
    mapping(uint256 => Product) public products;
    uint256 public productCount;
    
    // Events
    event ProductCreated(uint256 indexed id, string name, address manufacturer, uint256 timestamp);
    event ProductTransferred(uint256 indexed id, address from, address to, string location, uint256 timestamp);
    event ProductDelivered(uint256 indexed id, address recipient, string location, uint256 timestamp);
    
    /**
     * @dev Creates a new product in the supply chain
     * @param _name Name of the product
     * @param _description Description of the product
     * @param _location Initial location of the product
     * @return id of the newly created product
     */
    function createProduct(string memory _name, string memory _description, string memory _location) public returns (uint256) {
        productCount++;
        
        products[productCount] = Product({
            id: productCount,
            name: _name,
            description: _description,
            manufacturer: msg.sender,
            currentOwner: msg.sender,
            status: ProductStatus.Created,
            timestamp: block.timestamp,
            location: _location
        });
        
        emit ProductCreated(productCount, _name, msg.sender, block.timestamp);
        
        return productCount;
    }
    
    /**
     * @dev Transfers a product to a new owner
     * @param _productId ID of the product
     * @param _newOwner Address of the new owner
     * @param _location Current location during transfer
     */
    function transferProduct(uint256 _productId, address _newOwner, string memory _location) public {
        require(_productId > 0 && _productId <= productCount, "Product does not exist");
        require(products[_productId].currentOwner == msg.sender, "Only current owner can transfer");
        require(_newOwner != address(0), "Invalid new owner address");
        
        Product storage product = products[_productId];
        
        address previousOwner = product.currentOwner;
        product.currentOwner = _newOwner;
        product.status = ProductStatus.InTransit;
        product.timestamp = block.timestamp;
        product.location = _location;
        
        emit ProductTransferred(_productId, previousOwner, _newOwner, _location, block.timestamp);
    }
    
    /**
     * @dev Marks a product as delivered to the final destination
     * @param _productId ID of the product
     * @param _location Final delivery location
     */
    function deliverProduct(uint256 _productId, string memory _location) public {
        require(_productId > 0 && _productId <= productCount, "Product does not exist");
        require(products[_productId].currentOwner == msg.sender, "Only current owner can deliver");
        
        Product storage product = products[_productId];
        
        product.status = ProductStatus.Delivered;
        product.timestamp = block.timestamp;
        product.location = _location;
        
        emit ProductDelivered(_productId, msg.sender, _location, block.timestamp);
    }
    
    /**
     * @dev Gets the details of a product
     * @param _productId ID of the product
     * @return All details of the product
     */
    function getProduct(uint256 _productId) public view returns (
        uint256 id,
        string memory name,
        string memory description,
        address manufacturer,
        address currentOwner,
        ProductStatus status,
        uint256 timestamp,
        string memory location
    ) {
        require(_productId > 0 && _productId <= productCount, "Product does not exist");
        
        Product storage product = products[_productId];
        
        return (
            product.id,
            product.name,
            product.description,
            product.manufacturer,
            product.currentOwner,
            product.status,
            product.timestamp,
            product.location
        );
    }
}
