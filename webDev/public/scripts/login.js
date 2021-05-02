$(document).ready(function(){
    slideShow();
})

var slideIndex = 1;
var slideNum = 5;
function slideShow(){
    var slides = document.getElementById("mainBody");

    for (let i = 0; i < slideNum; i++){
        slides.style.backgroundImage = "none"; 
    }
    
    if (slideIndex > slideNum){
        slideIndex = 1;
    }
    console.log('url("../images/slideShow' + slideIndex + '.jpg")')
    slides.setAttribute("style", "background-image: url(images/slideShow" + slideIndex + ".jpg)");
    
    slideIndex++;
    setTimeout(() => {  slideShow(); }, 3000);
}

function keyPress(){
    let showPassword = document.getElementById('pswd');
    if (showPassword.type == "password"){
        showPassword.type = "text";
        setTimeout(() => {  showPassword.type = "password"; }, 1800);
    }
}

function login(){
    $('#body').empty();
    
    let mainBody = document.getElementById('body');
    let div = document.createElement('div');
    div.setAttribute('id', 'logindiv')
    let header = document.createElement('p');
    header.innerHTML = "Log In";
    header.setAttribute('class', 'loginheader');
    div.appendChild(header);

    let divInfo = document.createElement('div');
    let infoOne = document.createElement('p');
    infoOne.innerHTML = "Welcome to Foodies!";
    divInfo.appendChild(infoOne);

    let infoTwo = document.createElement('p');
    infoTwo.innerHTML = "Please Log in";
    infoTwo.setAttribute('id', 'coloured');
    divInfo.appendChild(infoTwo);

    div.appendChild(divInfo);

    let form = document.createElement('form');
    form.setAttribute('id', 'signIn');
    form.setAttribute('method', 'post');
    form.setAttribute('action', '/login');

    let labelOne = document.createElement('label');
    labelOne.innerHTML = "Enter Username:";

    let username = document.createElement('input');
    username.type = "text";
    username.setAttribute('name','loginUser');

    let labelTwo = document.createElement('label');
    labelTwo.innerHTML = "Enter Password:";

    let password = document.createElement('input');
    password.type = "password";
    password.setAttribute('name','loginPass');

    let submit = document.createElement('input');
    submit.onsubmit = "return false";
    submit.id = "submit";
    submit.type = "submit";
    submit.value = "Login";

    form.appendChild(labelOne);
    form.appendChild(username);
    form.appendChild(labelTwo);
    form.appendChild(password);
    form.appendChild(submit);

    div.appendChild(form);
    mainBody.appendChild(div);
}

function createAccount(){
    $('#body').empty();
    
    let mainBody = document.getElementById('body');
    let div = document.createElement('div');
    div.setAttribute('id', 'logindiv')
    let header = document.createElement('p');
    header.innerHTML = "Create an Account";
    header.setAttribute('class', 'loginheader');
    div.appendChild(header);

    let divInfo = document.createElement('div');
    let infoOne = document.createElement('p');
    infoOne.innerHTML = "Welcome to Foodies!";
    divInfo.appendChild(infoOne);

    let infoTwo = document.createElement('p');
    infoTwo.innerHTML = "Please Create Account";
    infoTwo.setAttribute('id', 'coloured');
    divInfo.appendChild(infoTwo);

    div.appendChild(divInfo);

    let form = document.createElement('form');
    form.setAttribute('id', 'signIn');
    form.setAttribute('method', 'post');
    form.setAttribute('action', '/create');



    let labelOne = document.createElement('label');
    labelOne.innerHTML = "Create Username:";
    let username = document.createElement('input');
    username.type = "text";
    username.setAttribute('name','createUser');

    let labelTwo = document.createElement('label');
    labelTwo.innerHTML = "Create Password:";
    let password = document.createElement('input');
    password.type = "password";
    password.setAttribute('name','createPass');

    let submit = document.createElement('input');
    submit.onsubmit = "return false";
    submit.id = "submit";
    submit.type = "submit";
    submit.value = "Create Account";

    form.appendChild(labelOne);
    form.appendChild(username);
    form.appendChild(labelTwo);
    form.appendChild(password);
    form.appendChild(submit);

    div.appendChild(form);
    mainBody.appendChild(div);
}
