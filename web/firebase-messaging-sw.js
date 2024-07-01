importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts(
  "https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js"
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

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
