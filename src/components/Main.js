import React, { Component } from "react";

class Main extends Component {
  render() {
    console.log(this.props)
    return (
      <div id="content">
        <h1>Produtos</h1>
        <form className="form-group"
          onSubmit={event => {
            event.preventDefault();
            const name = this.productName.value;
            const price = window.web3.utils.toWei(
              this.productPrice.value.toString(),
              "Ether"
            );
            this.props.createProduct(name, price);
          }}
        >
          <div className="row">
            <div className="col">
              <input
                id="productName"
                type="text"
                ref={input => {
                  this.productName = input;
                }}
                className="form-control"
                placeholder="Nome do produto"
                required
              />
            </div>

            <div  className="col">
                <input
                  id="productPrice"
                  type="text"
                  ref={input => {
                    this.productPrice = input;
                  }}
                  className="form-control"
                  placeholder="Valor(em Ether)"
                  required
                />
            </div>
            <div className="col">
              <button type="submit" className="btn btn-primary">
                Salvar
              </button>
            </div>
          </div>
        </form>
        <p>&nbsp;</p>
        <h2>Comprar produto</h2>
        <table className="table">
          <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col">Nome</th>
              <th scope="col">Preço</th>
              <th scope="col">Proprietário</th>
              <th scope="col"></th>
            </tr>
          </thead>
          <tbody id="productList">
            {this.props.products.map((product, key) => {
              return (
                <tr key={key}>
                  <th scope="row">{product.id.toString()}</th>
                  <td>{product.name}</td>
                  <td>
                    {window.web3.utils.fromWei(
                      product.price.toString(),
                      "ether"
                    )}{" "}
                    Eth
                  </td>
                  <td>{product.owner}</td>
                  <td>
                    <div class="row">
                      <div class="col">
                        {!product.purchased ? (
                          <button
                            className="btn btn-success"
                            name={product.id}
                            value={product.price}
                            onClick={event => {
                              this.props.purchaseProduct(
                                event.target.name,
                                event.target.value
                              );
                            }}
                          >
                            Comprar
                          </button>
                        ) : null}
                      </div>
                      <div class="col">
                        {!product.purchased ? (
                          <button
                            className="btn btn-info"
                            name={product.id}
                            value={product.price}
                            onClick={event => {
                              this.props.purchaseProduct(
                                event.target.name,
                                event.target.value
                              );
                            }}
                          >
                            Editar
                          </button>
                        ) : null}
                      </div>
                    </div>
                    <div></div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
        <p>
          <a
            href="https://ropsten.etherscan.io/address/0x781c71bfe45d1c5d81fca75d17bb589cc72d63fc"
            target="_blank"
          >
            Informação do contrato
          </a>
        </p>
      </div>
    );
  }
}

export default Main;
