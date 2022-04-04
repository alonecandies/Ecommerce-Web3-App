import { useEffect, useState } from "react";
import Header from "../../components/Header";
import Foods from "../../components/Foods";
import { getProducts } from "../../server/firebase";

const Home = () => {
  const [products, setProducts] = useState([]);

  useEffect(() => {
    getProducts().then((products) => {
      if (products) {
        products.filter((item) => {
          item.price = Number(item.price);
          item.qty = 0;
        });
        setProducts(products);
      } else {
        setProducts([]);
      }
    });
  }, []);

  return (
    <div className="home">
      <Header />
      <Foods products={products} />
    </div>
  );
};

export default Home;
