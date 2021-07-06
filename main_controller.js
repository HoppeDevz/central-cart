const { server_identifier, client_domain, verify_timeout, api_protocol } = require("./config");
const DeliveryController = require("./controllers/DeliveryController");

const MainThread = new DeliveryController(server_identifier, client_domain, verify_timeout, api_protocol);

MainThread.startThread();
MainThread.banner();