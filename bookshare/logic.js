var socket = io();
var curid, curcat;
var prev = "sci";
var modifier = function (id, name) {
  curid = id;
  document.querySelector("#dialog-" + name).style.display = "block";
};

var ondialogsubmit = function (dialog, values, callback) {
  document.querySelector("#abort" + dialog).onclick = function () {
    document.querySelector("#dialog-" + dialog).style.display = "none";
  };
  document.querySelector("#complete" + dialog).onclick = function () {
    var results = {};
    values.forEach(function(val){
      results[val] = document.querySelector("#" + dialog + val).value;
    });
    callback(results);
    document.querySelector("#dialog-" + dialog).style.display = "none";
  };
};

var Listing = function (name, id, category) {
  this.name = name;
  this.id = id;
  var list = document.querySelector("#listings-" + category);
  list.classList.remove("empty");
  
  var listingbox = document.createElement("div");
  listingbox.innerHTML = `<div>${name}</div>
  <button id='request-${id}'>Request</button>
  <button id='remove-${id}'>Remove</button>`;
  list.appendChild(listingbox);

  document.querySelector("#request-" + id).onclick = function () {
    modifier(id, "request");
  };

  document.querySelector("#remove-" + id).onclick = function () {
    modifier(id, "remove");
  };
};

var tab = function (tabcode) {
  document.querySelector("#" + prev + "btn").classList.remove("selected");
  document.querySelector("#" + tabcode + "btn").classList.add("selected");
  document.querySelector("#listings-" + prev).style.display = "none";
  document.querySelector("#listings-" + tabcode).style.display = "block";
  prev = tabcode;
};

socket.on("connect", function () {
  ondialogsubmit("add", ["category", "name", "email"], function (v) {
    socket.emit("add-listing", v.email, v.name, v.category);
  });
  ondialogsubmit("remove", ["code"],  function (v) {
    socket.emit("remove-listing", curid, v.code);
  });
  ondialogsubmit("request", ["address"], function (v) {
    socket.emit("request-listing", curid, v.address);
  });
  socket.on("listings", function (listings) {
    listings.forEach(function(listing) {
      new Listing(listing.information, listing.index, listing.category);
    });
  });
  socket.on("reload", function () { window.location.reload(); });
});

document.querySelector("#addbtn").onclick = function () {
  modifier(null, "add");
};

tab("mag");
document.querySelector("#magbtn").onclick = function () { tab("mag"); };
document.querySelector("#scibtn").onclick = function () { tab("sci"); };
document.querySelector("#nfbtn").onclick = function () { tab("nf"); };
document.querySelector("#ficbtn").onclick = function () { tab("fic"); };
document.querySelector("#relbtn").onclick = function () { tab("rel"); };
