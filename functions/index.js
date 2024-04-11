const cors = require('cors')({origin: true}); // Dodaj tę linię
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const fetch = require('node-fetch');

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

const db = admin.firestore();

function someAsyncFunction() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve('Udało się! To jest symulowany wynik asynchronicznej operacji.');
    }, 2000); // Symulacja opóźnienia 2 sekundy
  });
}

function fetchBinanceData() {
  const url = 'https://api.binance.com/api/v3/ticker/price';
  // Zwraca Promise
  return fetch(url).then(response => {
    if (!response.ok) {
      throw new Error(`API call failed with status: ${response.status}`);
    }
    return response.json(); // Parsuje i zwraca ciało odpowiedzi jako JSON
  });
}

exports.binanceAPIRequest = functions.region('europe-central2').https.onRequest((request, response) => {
    try {
        const symbol = "BTCUSDT"; // Parametr zapytania, np. "BTCUSDT"
        const endpoint = `https://api.binance.com/api/v3/ticker/price?symbol=${symbol}`;

        fetch(endpoint)
            .then(res => res.json())
            .then(data => {
                // Sprawdzenie, czy odpowiedź zawiera błąd
                if (data.code) {
                    response.status(400).send({ error: 'Error occurred while fetching data from Binance API' });
                } else {
                    // Jeśli wszystko jest w porządku, zwróć dane
                    response.status(200).send(data);
                }
            })
            .catch(error => {
                console.error('Error occurred:', error);
                response.status(500).send({ error: 'Internal server error' });
            });
    } catch (error) {
        console.error('Error occurred:', error);
        response.status(500).send({ error: 'Internal server error' });
    }
});

// Określenie regionu funkcji
exports.binanceAPIRequest.region = 'europe-west1';

//exports.updateCryptoData = functions.region('europe-west1').https.onRequest(async (request, response) => {
//           cors (request, response, async () => {
//               // Tutaj umieść logikę swojej funkcji
//                    fetchBinanceData().then(data => {
//                        // Wysyła dane JSON otrzymane z API Binance jako odpowiedź HTTP
//                        response.send(data);
//                      }).catch(error => {
//
//                        response.send(error);
//                      });
//             });
//
// //const symbols = ['BTC', 'ETH', 'BNB', 'SOL', 'XRP', 'DOGE', 'ADA', 'AVAX', 'SHIB', 'BCH', 'DOT', 'TRX', 'LINK', 'MATIC', 'NEAR', 'ICP', 'LTC', 'UNI', 'DAI', 'APT', 'ETC', 'STX', 'FIL', 'ATOM', 'ARB', 'XLM', 'IMX', 'RNDR', 'HBAR', 'VET', 'GRT', 'MKR', 'OP', 'INJ', 'THETA', 'FTM', 'RUNE', 'XMR', 'AAVE', 'FLOW', 'NEO', 'EOS'];
////     try {
////       for (const symbol of symbols) {
////         // Fetch historical data
////         const urlRSI = `https://api.binance.com/api/v3/klines?symbol=${symbol}USDT&interval=1d&limit=59`;
////         const responseRSI = await fetch(urlRSI);
////         const dataRSI = await responseRSI.json();
////         const closingPricesRSI = dataRSI.map(kline => parseFloat(kline[4]));
////
////         const urlSMA = `https://api.binance.com/api/v3/klines?symbol=${symbol}USDT&interval=1d&limit=200`;
////         const responseSMA = await fetch(urlSMA);
////         const dataSMA = await responseSMA.json();
////         const closingPricesSMA = dataSMA.map(kline => parseFloat(kline[4]));
////
////         // Calculate RSI
////         let gains = 0, losses = 0;
////         for (let i = 1; i < closingPricesRSI.length; i++) {
////             const diff = closingPricesRSI[i] - closingPricesRSI[i - 1];
////             if (diff >= 0) gains += diff;
////             else losses -= diff;
////         }
////         const averageGain = gains / 14;
////         const averageLoss = losses / 14;
////         const rs = averageGain / averageLoss;
////         const rsi = 100 - (100 / (1 + rs));
////
////         // Calculate SMA
////         const sum = closingPricesSMA.reduce((acc, price) => acc + price, 0);
////         const sma = sum / closingPricesSMA.length;
////
////         // Update Firestore
////         await db.collection('rsi').doc('rsi').set({symbol: rsi }, { merge: true });
////         await db.collection('sma').doc('sma').set({symbol: sma }, { merge: true });
////       }
////
////       response.json({ status: 'success', message: 'Dane RSI i SMA zostały zaktualizowane.' });
////     } catch (error) {
////       console.error('Błąd:', error);
////       response.status(500).json({ status: 'error', message: 'Wystąpił błąd podczas aktualizacji danych.' });
////     }
//
//});

