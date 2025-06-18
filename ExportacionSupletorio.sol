// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract SafeMachineryDeal {

    address public exporter;  // Vendedor (China)
    address public importer;  // Comprador (Ecuador)
    uint public totalPrice;   // Precio total en Wei
    bool public depositPaid;  // Estado del adelanto
    bool public delivered;    // Estado de entrega

    constructor(address _exporter, uint _totalPrice) {
        exporter = _exporter;
        importer = msg.sender;
        totalPrice = _totalPrice;
    }

    // Pagar adelanto (50%)
    function payDeposit() external payable {
        require(msg.sender == importer, "Solo importador");
        require(!depositPaid, "Ya pagado");
        require(msg.value == totalPrice / 2, "Debe ser 50%");
        depositPaid = true;
    }

    // Confirmar entrega y pagar saldo (50%)
    function confirmDeliveryAndPayBalance() external payable {
        require(msg.sender == importer, "Solo importador");
        require(depositPaid, "Primero paga adelanto");
        require(!delivered, "Ya entregado");
        require(msg.value == totalPrice / 2, "Debe ser saldo restante");
        delivered = true;
    }

    // Exportador retira todo si ya está pagado y confirmado
    function withdraw() external {
        require(msg.sender == exporter, "Solo exportador");
        require(depositPaid && delivered, "Pago incompleto");
        payable(exporter).transfer(address(this).balance);
    }
}
