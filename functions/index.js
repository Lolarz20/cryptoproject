const cors = require('cors')({origin: true}); // Dodaj tę linię
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const fetch = require('node-fetch');
const axios = require('axios');

admin.initializeApp({
  credential: admin.credential.cert({
    "type": "service_account",
      "project_id": "cryptoprojectriddep",
      "private_key_id": "", // API Key deprecated
      "private_key": "", // API Key deprecated
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
                     username: '', // API Key deprecated
                     password: '' // API Key deprecated
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

