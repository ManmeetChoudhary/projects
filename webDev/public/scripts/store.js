var ingredientsList = "";
$(document).ready(function(){
    dailySpecial();

    buildCategories();
    
    $('#btn').click(function() {
        var name = $('[name="productName"]').val();
        findItem(name);
    });
});

function dailySpecial(){
    $('#floatingBody').empty();
    var data = [];
    var dailySpecialImage = [];
    var dailySpecialName = [];
    var dailySpecialInstructions = [];

    for (let i = 0; i < 3; i++){ 
        fetch('https://www.themealdb.com/api/json/v1/1/random.php')
        .then((response) => response.json())
        .then((json) => {
            data[i] = json.meals;
            dailySpecialImage[i] = data[i][0].strMealThumb
            dailySpecialName[i] = data[i][0].strMeal
            dailySpecialInstructions[i] = data[i][0].strInstructions
            
            if (i == 2){
                let body = document.getElementById('floatingBody');
                let dailySpecial = document.createElement('div');
                dailySpecial.setAttribute('id', 'dailySpecial');
                let header = document.createElement('div');
                header.setAttribute('id', 'special');
            
                let headerLabel = document.createElement('label');
                let headerP = document.createElement('p');
                headerLabel.innerHTML = "Daily Special:";
                headerP.innerHTML = "Welcome to Foodies! We have many recipes for your choosing. Here's 3 to start you off";
                header.appendChild(headerLabel);
                header.appendChild(headerP);
                dailySpecial.appendChild(header);

                for (let j = 0; j < 3; j++){
                    setTimeout(() => {
                    let itemOne = document.createElement('div');
                    itemOne.setAttribute('id', 'item');
                    let imageOne = document.createElement('img');
                    imageOne.setAttribute('src', dailySpecialImage[j]);
                    let labelOne = document.createElement('label');
                    labelOne.innerHTML = dailySpecialName[j];
                    let infoOne = document.createElement('p');
                    infoOne.innerHTML = dailySpecialInstructions[j];
                    infoOne.id = "itemTextField";
                    
                    itemOne.setAttribute('onclick', 'findItem("' + labelOne.innerHTML + '")');
                    itemOne.appendChild(imageOne);
                    itemOne.appendChild(labelOne);
                    itemOne.appendChild(infoOne);
                    dailySpecial.appendChild(itemOne);
                    }, 200);
                }

                body.appendChild(dailySpecial);
            }
        });
    }   
}

function buildCategories(){
    var data = [];
    var categoryNames = [];
    
    fetch('https://www.themealdb.com/api/json/v1/1/categories.php')
    .then((response) => response.json())
    .then((json) => {
        data = json.categories;

        let dataList = document.getElementById('categories');
        for (let i = 0; i < data.length; i++){
            let option = document.createElement('p');
            option.setAttribute('onclick', 'getFoodID("' + data[i].strCategory + '")');
            option.innerHTML = data[i].strCategory;
            dataList.appendChild(option);

            categoryNames[i] = data[i].strCategory;
        }

        buildSearchBar(categoryNames);
    });
}

function getEveryFoodName(category){
    var data = [];

    fetch('https://www.themealdb.com/api/json/v1/1/filter.php?c=' + category)
    .then((response) => response.json())
    .then((json) => {
        data = json.meals;

        let datalist = document.getElementById('productName');
        for (let i = 0; i < data.length; i++){
            let option = document.createElement('option');
            option.value = data[i].strMeal;
            datalist.appendChild(option);
        }
    });
}

function buildSearchBar(names){
    for (let i = 0; i < names.length; i++){
        getEveryFoodName(names[i])
    }
}

function getFoodID(category){
    $('#floatingBody').empty();
    var data = [];
    var foodID = [];

    fetch('https://www.themealdb.com/api/json/v1/1/filter.php?c=' + category)
    .then((response) => response.json())
    .then((json) => {
        data = json.meals;
        for (let i = 0; i < data.length; i++){
            foodID[i] = data[i].idMeal;
        }
        getCategories(foodID);
    });
}

function getCategories(id){
    var foodData = [];
    var dailySpecialImage = [];
    var dailySpecialName = [];
    var dailySpecialInstructions = [];

    for (let i = 0; i < id.length; i++){
        fetch('https://www.themealdb.com/api/json/v1/1/lookup.php?i=' + id[i])
        .then((response) => response.json())
        .then((json) => {
            foodData = json.meals;

            dailySpecialImage[i] = foodData[0].strMealThumb
            dailySpecialName[i] = foodData[0].strMeal
            dailySpecialInstructions[i] = foodData[0].strInstructions

            if (i+1 == foodData.length){
                let body = document.getElementById('floatingBody');
                let dailySpecial = document.createElement('div');
                dailySpecial.setAttribute('id', 'category');
                let header = document.createElement('div');
                header.setAttribute('id', 'special');
    
                for (let j = 0; j < id.length; j++){
                    setTimeout(() => {
                    let itemOne = document.createElement('div');
                    itemOne.setAttribute('id', 'item');
                    let imageOne = document.createElement('img');
                    imageOne.setAttribute('src', dailySpecialImage[j]);
                    let labelOne = document.createElement('label');
                    labelOne.innerHTML = dailySpecialName[j];
                    let infoOne = document.createElement('p');
                    infoOne.innerHTML = dailySpecialInstructions[j];
                    infoOne.id = "itemTextField";

                    itemOne.setAttribute('onclick', 'findItem("' + labelOne.innerHTML + '")');
                    itemOne.appendChild(imageOne);
                    itemOne.appendChild(labelOne);
                    itemOne.appendChild(infoOne);
                    dailySpecial.appendChild(itemOne);
                    }, 200);
                }
    
                body.appendChild(dailySpecial);
            }
        });
    }
}

function findItem(name){
    var item;

    let option = document.getElementById('productName').options;
    // console.log(option[0])
    for (let i = 0; i < option.length; i++){
        if (name == option[i].value){
            item = name;
        }
    }
    if (item != null){
        displayItem(item);
    }
}
// save html to variable
function displayItem(item){
    let bar = document.getElementById('search');
    bar.value = "";
    $('#floatingBody').empty();
    item = item.replace(/ /g, '_');
    var ingredients;
    var measurements;

    fetch('https://www.themealdb.com/api/json/v1/1/search.php?s=' + item)
        .then((response) => response.json())
        .then((json) => {
        data = json.meals;

        let floatingBody = document.getElementById('floatingBody');
        let darkened = document.createElement('div');
        darkened.id = "darkened";
        let itemDisplay = document.createElement('div');
        itemDisplay.id = "itemDisplay";
        let closeBtn = document.createElement('button');
        closeBtn.setAttribute('onclick', "dailySpecial()");
        closeBtn.innerHTML = "X";
        itemDisplay.appendChild(closeBtn);

        let gridDiv = document.createElement('div');
        let image = document.createElement('img');
        image.src = data[0].strMealThumb;
        gridDiv.appendChild(image);

        let headerDiv = document.createElement('div');
        let header = document.createElement('h1');
        header.id = "itemHeader";
        header.innerHTML = data[0].strMeal;
        headerDiv.appendChild(header);

        let tags = document.createElement('p');
        tags.innerHTML = "Tags:";
        let spanTag = document.createElement('span');
        spanTag.innerHTML = data[0].strTags;
        tags.appendChild(spanTag);
        let pIngredients = document.createElement('p');
        pIngredients.innerHTML = "Ingredients:";
        tags.appendChild(pIngredients);
        headerDiv.appendChild(tags);

        for (let i = 1; i < 21; i++){
            ingredients = 'strIngredient' + i;
            measurements = 'strMeasure' + i;
            
            if (data[0][ingredients] != ""){
                if (data[0][measurements] != null){
                    let ingredient = document.createElement('p');
                    ingredient.innerHTML = data[0][ingredients];
        
                    let measurement = document.createElement('span');
                    measurement.innerHTML = "- " + data[0][measurements];
                    ingredient.appendChild(measurement);

                    ingredientsList += data[0][ingredients] + "- " + data[0][measurements] + ', '

                    headerDiv.appendChild(ingredient);
                }
            }
        }
        
        gridDiv.appendChild(headerDiv);
        itemDisplay.appendChild(gridDiv);

        let instructionHeader = document.createElement('h');
        instructionHeader.innerHTML = "Instructions:";
        itemDisplay.appendChild(instructionHeader);

        let instructions = document.createElement('p');
        instructions.innerHTML = data[0].strInstructions;
        itemDisplay.appendChild(instructions);

        let form = document.createElement('form');
        form.setAttribute('id', 'sendMail');
        form.setAttribute('method', 'post');
        form.setAttribute('action', '/email');

        let hiddenName = document.createElement('input');
        hiddenName.type = "text";
        hiddenName.id = "hiddenName";
        hiddenName.setAttribute('name','hiddenName');
        hiddenName.value = data[0].strMeal;

        
        let hiddenIngredients = document.createElement('input');
        hiddenIngredients.type = "text";
        hiddenIngredients.id = "ingredientsInfo";
        hiddenIngredients.setAttribute('name','ingredientsInfo');
        hiddenIngredients.value = ingredientsList;

        let hiddenInstructions = document.createElement('input');
        hiddenInstructions.type = "text";
        hiddenInstructions.id = "instructionInfo";
        hiddenInstructions.setAttribute('name','instructionInfo');
        hiddenInstructions.value = data[0].strInstructions;

        let formHeader = document.createElement('label');
        formHeader.innerHTML = "Send the recipe to yourself or share with a friend!";
        formHeader.id = "emailHeader";

        let email = document.createElement('input');
        email.type = "text";
        email.id = "emailInfo";
        email.placeholder = "Enter an Email"
        email.setAttribute('name','emailInfo');
        email.setAttribute('id','emailInfo');

        let submit = document.createElement('input');
        submit.onsubmit = "return false";
        submit.id = "submitMail";
        submit.type = "submit";
        submit.value = "Get Recipe";

        form.appendChild(hiddenName);
        form.appendChild(hiddenIngredients);
        form.appendChild(hiddenInstructions);
        form.appendChild(formHeader);
        form.appendChild(email);
        form.appendChild(submit);
        itemDisplay.appendChild(form);

        let spacer1 = document.createElement('div');
        spacer1.id = "spacer";
        itemDisplay.appendChild(spacer1);

        darkened.appendChild(itemDisplay);
        floatingBody.appendChild(darkened);
    });
}