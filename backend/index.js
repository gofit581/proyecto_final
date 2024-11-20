import express from "express";
import cors from "cors";
import { MercadoPagoConfig, Preference} from "mercadopago";


const client = new MercadoPagoConfig({accessToken: "APP_USR-2895292226517850-110717-f814a027703fac30e6e1888c13963103-256622141"})


const app = express();
const port = 3000;

app.use(cors());

app.use(express.json());

app.get("/", (req, res) =>{
    res.send(" Soy el server :) ");
});

app.listen(port,()=>{
    console.log(`Escuchando en el puerto${port}`);
});

app.post("/create_preferences", async (req,res)=>{
    try {
        const { title, quantity, unit_price, currency_id } = req.body;
        const body ={
            items: [
                {
                    title: title,
                    quantity: Number(quantity),
                    unit_price: Number(unit_price),
                    currency_id: currency_id,
                },
            ],

            back_urls: {
                success: "miapp://success",
                failure: "miapp://failure",
                pending: "miapp://pending"
              },
            auto_return:"approved"
        };


        const preferences = new Preference(client);
        const result = await preferences.create({body});
        console.log(result);
        res.json({
            url:result.sandbox_init_point,
            id:result.id,
        });
    } catch (error) {
        console.log(error);
        res.status(500).json({
            error:"Error al crear la preferencia"
        });
    }

});