# Clean Eats 

[Please click here to watch the video of the app](https://youtube.com/watch?v=ZQMmyTXGzK4)

This project aims to facilitate the process of selecting diet types and viewing daily meal plans for users in a simple and effective way. The project utilizes the **Spoonacular API** and leverages the **Alamofire library** to fetch data, such as recipes and diet information, from the API. The project follows the **MVVM design pattern** for organization.

## Spoonacular API Integration:

The project uses the Spoonacular API to retrieve data, such as meal recipes and diet types. The Alamofire library is used for making API requests. The API integration is achieved through the following key steps:

1. The DailyList class generates the weekly meal plan by making requests to the Spoonacular API through the generateWeeklyMealPlan() function. This function sends requests to the API based on the selected diet type and number of meals, obtaining meals for each day of the week.

2. The fetchMealDetails(for:) function makes requests to the Spoonacular API using the meal ID (mealId) to retrieve details of the selected meals. This function enables the display of meal details on the MealDetail screen.

## DietTypes Screen

  <p align="center">
  <img src="https://github.com/oykuhazer/CleanEats/assets/130215854/ccb1458d-4b88-43c9-859a-7afc9db2366d" alt="zyro-image" width="200" height="450">
</p>

This screen presents a list of various diet types for users to choose from. A collection is displayed, listing different diet types. Each cell in the collection represents a specific diet type. Users can select a diet type by tapping on any cell in the collection.

## DailyList Screen

 <p align="center">
  <img src="https://github.com/oykuhazer/CleanEats/assets/130215854/3c026b62-642b-49d9-ba6e-97d35433880c" alt="zyro-image" width="200" height="450" />
  <img src="https://github.com/oykuhazer/CleanEats/assets/130215854/0b45cf9f-ba9e-4032-84ad-00a8ccd9abde" alt="zyro-image" width="200" height="450" />
</p>

When a user taps on a cell representing a diet type, they are redirected to the "DailyList" screen, where the corresponding daily meal plan for the selected diet type is displayed. At the top of the screen, there is a label ("Selected Diet Category") showing the selected diet type. The label displays the name of the chosen diet type. If no diet type is selected, a text saying "No Diet Selected" is displayed. At the bottom of the screen, there is a table showing the daily meal plan. The table represents each day of the week with rows containing three meal items for each day. The meals in the table will be populated with recipes suitable for the chosen diet type.

## MealDetail Screen

 <p align="center">
  <img src="https://github.com/oykuhazer/CleanEats/assets/130215854/c9046e23-af37-4615-9632-c36b379f0006" alt="zyro-image" width="200" height="450" />
    <img src="https://github.com/oykuhazer/CleanEats/assets/130215854/9c542974-a7bf-45b0-b056-3cf00ae1f865" alt="zyro-image" width="200" height="450" />
  <img src="https://github.com/oykuhazer/CleanEats/assets/130215854/672653d1-4ada-4724-b247-6174a6f7658e" alt="zyro-image" width="200" height="450" />
    <img src="https://github.com/oykuhazer/CleanEats/assets/130215854/9789df3f-577a-4393-96d5-284b3e0758b0" alt="zyro-image" width="200" height="450" />
</p>

If a user taps on any meal item in the daily meal plan, they are directed to the "MealDetail" screen, which displays detailed information about the selected meal. At the bottom of the screen, there is a button providing a link to the source of the meal. By clicking the button, the user is redirected to the Spoonacular website, where they can find the complete recipe or more information about the meal.

