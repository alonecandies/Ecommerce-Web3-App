import React from "react";
import { BrowserRouter } from "react-router-dom";
import "@material-tailwind/react/tailwind.css";
import { initCometChat } from "./server/cometChat";
import App from "./App";
import { createRoot } from "react-dom/client";

const container = document.getElementById("root");
const root = createRoot(container);

initCometChat().then(() => {
  root.render(
    <BrowserRouter>
      <App />
    </BrowserRouter>,
  );
});
