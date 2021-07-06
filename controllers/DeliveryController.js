const axios = require("axios");
const { Wait } = require("../lib/utils");
const net_events = require("../net_events");

class DeliveryController {

    constructor(server_identifier, client_domain, verify_timeout, api_protocol) {
    
        this.server_identifier = server_identifier;
        this.client_domain = client_domain;
        this.verify_timeout = verify_timeout;
        this.api_protocol = api_protocol;   
    }

    startThread() {
    
        setTick(async () => {

            axios.default.get(
                `${this.api_protocol}://${this.client_domain}/api/v1/products/waiting/`,
                {
                    headers: {
                        ["X-PLATFORM-TOKEN"]: this.server_identifier
                    }
                }
            )
            .then(response => {
        
                const products = response.data;
                const productsSucessDeliveried = [];
        
                for (let product of products) {
        
                    let { id, user_id, argument, amount, platform, token, command, type } = product;
        
                    user_id = parseInt(user_id);
        
                    emit(net_events[type], user_id, argument, amount,  sucess => {

                        console.log(`^2[ENTREGA] [PEDIDO] [${id}] => ^3`, sucess)
        
                        if (sucess) {
        
                            emit("fxserver_events:user-notify", user_id, argument, amount);
                            emit("fxserver_events:global_chat_message", user_id, argument, amount);
        
                            productsSucessDeliveried.push(id);
                        }
        
                    });
                }
        
                
                let reqBody =  { usage: productsSucessDeliveried.join(",") };
                let reqOptions = { headers: { ["X-PLATFORM-TOKEN"]: this.server_identifier } };
                
        
                // remove from list;
                axios.default.post(`${this.api_protocol}://${this.client_domain}/api/v1/products/conclude`, reqBody, reqOptions);
        
            })
            .catch(err => {
                console.log(err);
            })
        
            await Wait(this.verify_timeout);
        });
    }

    banner() {

        console.log(`
        ============================= [ SCRIPT OFICIAL CENTRALCART ] ==============================

        ██████╗███████╗███╗   ██╗████████╗██████╗  █████╗ ██╗      ██████╗ █████╗ ██████╗ ████████╗
        ██╔════╝██╔════╝████╗  ██║╚══██╔══╝██╔══██╗██╔══██╗██║     ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝
        ██║     █████╗  ██╔██╗ ██║   ██║   ██████╔╝███████║██║     ██║     ███████║██████╔╝   ██║   
        ██║     ██╔══╝  ██║╚██╗██║   ██║   ██╔══██╗██╔══██║██║     ██║     ██╔══██║██╔══██╗   ██║   
        ╚██████╗███████╗██║ ╚████║   ██║   ██║  ██║██║  ██║███████╗╚██████╗██║  ██║██║  ██║   ██║   
         ╚═════╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
         
        ============================= [ SCRIPT OFICIAL CENTRALCART ] ==============================
        `);
    }
}

module.exports = DeliveryController;