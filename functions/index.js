const cors = require('cors')({origin: true}); // Dodaj tę linię
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const fetch = require('node-fetch');
const axios = require('axios');

admin.initializeApp({
  credential: admin.credential.cert({
    "type": "service_account",
      "project_id": "cryptoprojectriddep",
      "private_key_id": "f3c92921aa939583aecc1742594e1c305c17c319",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCWhLjEvyffGj5q\n/97JLSWHXOPeRzX3Ad9avGFAMTr00eCIsC/7Ud4xrU4ruw95YWKe4Z0F8mUUbNnt\nrkOchmY/BPic1UoUMgd9BIfiDI1x3WVlkR/SykHElixoKVBOunyTMYKybeC8gY8S\n6J5fEvGAsbH1b8VmCt8xWfm/Sx/MLfQGpYEiH9xkwxiy0DemzO7wVR19+WgRrkL6\nFFDuDOOGNQsfkpPR8dp9nyBPnpcmNVTU2duLmKqOONYCD7uQEAQu05IQsrBchmsj\n3aNgg01QM32it9p4HtWH8w9pbGN1J1IJF+vUkMWQ/1FwN8bWRjer+R+Q1SE3/JJH\nqzgaJDVlAgMBAAECggEAJJWpWE7zGL/m/HhpNOI3jTV3gFM0K2/F02bWx3S/1Po/\nVlHms7IULORoC+qJahIQ17fUQ/oE9gg4FxSEhALJztb9O5d/DDYVyl4Dzh6Jcavj\npaJ2xvQYtLjgnceu6JfcyCUgVJCu73qZJTorpkWzM/nc3KBYbUNGuRbaxJN0rNp9\n/gXnqK+UYQAVvFiReGJp2iAZ8R7y46l3g+VQPO3FcHIwMG/vDsPw1gNBF5yoz2st\nBxCwLh+jLMck2MwTqSE79/4Vhh55blz5gTK4qjktiTCe8c0S9IZtIOAwhGCN8DV6\nWDc6KKTQqTz2Y/qZrG5nQWyZw2yfLDA9GXk9Q6RwEQKBgQDNyVYviWPtgfL2sS79\nLZz+7rWMvzHGtNKLPdnSmToilDZsB84eWv6f2VxtqxeMaqfMIe6ZSL1n+rxsgfyQ\nMOZE2nSdx6umEdVnsc0KDrSMy96mmpVSNU0xe+fbb2oSBVf6PbYB58+PLHe+IZJu\nfoThzy6xCYGlreqMiKfHKwxmkQKBgQC7PwLRSrSMJeoQUDA1JH+mdNyS+LWv0yz+\niNcKIS/QuDWEniXNJjFrHunX3pN/jUvqrBn0EP+6gf7b4xT3TmL2elFfuaAbth2x\nL+N7SaNU9Z0jM6vNnC4RKir6LQqkUayMWQYNt5eSS1H0zaKz9ZulUAKykrbcRzRC\n4Ic5XLPTlQKBgDFHe5oanpFrwxEMUSJT3/q0k0lHJ9ZbyueJQjZKdz98mqO4IsXm\nKH+C/71LcXIwwEoD/i063BCgXKrnXeHxs9LdNXvrKtG0B5SzYVR9PQNSdtkSv5tW\nJEwrTdSgk5gJK45DZOiD6JJypaIkS/ql1ZB1msrOafuQ8FADEZqCVo/hAoGBAK74\nGnHoFP5BD49e3y1Jhd7NpK/RqDU8Z/cRd6AHkt6+w4PBJCGnZtZqdKk7Wyj9p8sK\nNtZSbCSkBLsEXzsZDHC1rAR/OJWsf+JqlW9HSFDDkqqqRghDwOhZNv+/xwn1J/+d\n0IJQ5FnX+CWBYmA3SdIYCe1EG4uLHdLAbJu1fHRhAoGAc9nJvQXgOwJCOuzafSkC\nUplBDLpLqIir7Bmse7lguqsvgV1p7X0drnvCGQZaEh+4tcUW8AEuh/bMwpBD5jqV\n+qgyL0KR5a+1YxW8uaZ3n7JyCS4N9ANnCIawxhNCmWevD1lElo1tg01LNhg+TJLZ\nzhzgmWXIoy9OaOWtKKAiwWo=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-i9k3d@cryptoprojectriddep.iam.gserviceaccount.com",
      "client_id": "109907690285025281126",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-i9k3d%40cryptoprojectriddep.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
  })
});

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

const db = admin.firestore();

 exports.getMarketData = functions.https.onRequest(async (req, res) => {
     cors(req, res, async () => {
         try {
             const proxyConfig = {
                 host: 'brd.superproxy.io',
                 port: 22225,
                 auth: {
                     username: 'brd-customer-hl_ff88772f-zone-datacenter_proxy1',
                     password: 'xuqpbl6plke0'
                 }
             };

             const axiosInstance = axios.create({
                 proxy: proxyConfig
             });

             // Predefiniowana lista symboli
          const symbols = ['BTC', 'ETH', 'BNB', 'SOL', 'XRP', 'DOGE', 'ADA', 'AVAX', 'SHIB', 'BCH', 'DOT', 'TRX', 'LINK', 'MATIC', 'NEAR', 'ICP', 'LTC', 'UNI', 'DAI', 'APT', 'ETC', 'STX', 'FIL', 'ATOM', 'ARB', 'XLM', 'IMX', 'RNDR', 'HBAR', 'VET', 'GRT', 'MKR', 'OP', 'INJ', 'THETA', 'FTM', 'RUNE', 'XMR', 'AAVE', 'FLOW', 'NEO', 'EOS']; // Lista symboli do obliczenia RSI

             const rsiData = {};
             const smaData = {};

             for (const symbol of symbols) {
                 try {
                     const closingPricesRSI = await fetchHistoricalDataRSI(symbol, axiosInstance);
                     const closingPricesSMA = await fetchHistoricalDataSMA(symbol, axiosInstance);
                     const rsi = calculateRSI(closingPricesRSI);
                     const sma = calculateSMA(closingPricesSMA);

                     rsiData[symbol] = rsi;
                     smaData[symbol] = sma;
                 } catch (error) {
                     console.error(`Błąd przy pobieraniu danych dla ${symbol}:`, error);
                 }
             }

             await db.collection('rsi').doc('rsi').set(rsiData, { merge: true });
             await db.collection('sma').doc('sma').set(smaData, { merge: true });

             res.status(200).send({ rsiData, smaData });
         } catch (error) {
             console.error('Błąd podczas pobierania informacji o giełdzie:', error);
             res.status(500).send('Nie można pobrać informacji o giełdzie');
         }
     });
 });

 async function fetchHistoricalDataRSI(symbol, axiosInstance, interval = '1m', limit = 59) {
     const url = `https://api.binance.com/api/v3/klines?symbol=${symbol}USDT&interval=${interval}&limit=${limit}`;
     const response = await axiosInstance.get(url);
     return response.data.map(kline => parseFloat(kline[4])); // Cena zamknięcia jest na 4 pozycji w każdym kline
 }

 async function fetchHistoricalDataSMA(symbol, axiosInstance, interval = '1m', limit = 200) {
     const url = `https://api.binance.com/api/v3/klines?symbol=${symbol}USDT&interval=${interval}&limit=${limit}`;
     const response = await axiosInstance.get(url);
     return response.data.map(kline => parseFloat(kline[4])); // Cena zamknięcia jest na 4 pozycji w każdym kline
 }

 function calculateRSI(closingPrices) {
     let gains = 0, losses = 0;
     for (let i = 1; i < closingPrices.length; i++) {
         const diff = closingPrices[i] - closingPrices[i - 1];
         if (diff >= 0) gains += diff;
         else losses -= diff;
     }
     const averageGain = gains / 14;
     const averageLoss = losses / 14;
     const rs = averageGain / averageLoss;
     const rsi = 100 - (100 / (1 + rs));
     return rsi;
 }

 function calculateSMA(closingPrices, period = 200) {
     if (closingPrices.length < period) {
         throw new Error("Nie ma wystarczającej liczby danych do obliczenia SMA.");
     }
     const sum = closingPrices.slice(-period).reduce((acc, price) => acc + price, 0);
     return sum / period;
 }

