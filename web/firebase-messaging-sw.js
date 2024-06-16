importScripts(
  "https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyDKlew3tPoDXjB9vyN0yvcxFy_VcWJawR4",
  appId: "1:757105304257:web:fcf313d670026837f8ea40",
  messagingSenderId: "757105304257",
  projectId: "redela-81338",
  authDomain: "redela-81338.firebaseapp.com",
  storageBucket: "redela-81338.appspot.com",
  measurementId: "G-GRYW8XM20W",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
