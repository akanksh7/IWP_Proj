-- MoodMeal Database Setup
-- Run this in phpMyAdmin or MySQL command line

-- Create database
CREATE DATABASE IF NOT EXISTS moodmeal;
USE moodmeal;

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Moods table
CREATE TABLE moods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    color VARCHAR(7) DEFAULT '#ffb347'
);

-- Recipes table
CREATE TABLE recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    ingredients TEXT NOT NULL,
    instructions TEXT NOT NULL,
    prep_time INT DEFAULT 0,
    cook_time INT DEFAULT 0,
    servings INT DEFAULT 1,
    mood_id INT,
    user_id INT,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mood_id) REFERENCES moods(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Favorites table
CREATE TABLE favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    recipe_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(id),
    UNIQUE KEY unique_favorite (user_id, recipe_id)
);

-- Insert default moods
INSERT INTO moods (name, description, color) VALUES
('Happy', 'Light, colorful, and energizing meals', '#FFD700'),
('Sad', 'Comfort foods that warm the soul', '#87CEEB'),
('Energetic', 'Quick, protein-rich, energizing meals', '#FF6347'),
('Relaxed', 'Simple, calming, easy-to-make dishes', '#98FB98'),
('Romantic', 'Elegant dishes perfect for date nights', '#FFB6C1'),
('Stressed', 'Quick comfort foods for busy times', '#DDA0DD');

-- Insert default user (password is 'password123')
INSERT INTO users (username, email, password) VALUES
('demo_user', 'demo@moodmeal.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- Insert sample recipes
INSERT INTO recipes (title, description, ingredients, instructions, prep_time, cook_time, servings, mood_id, user_id) VALUES

-- Happy Mood Recipes (mood_id = 1)
('Sunny Pancakes', 'Fluffy pancakes to brighten your morning', 
'2 cups flour\n2 eggs\n1 cup milk\n2 tbsp sugar\n1 tsp baking powder\n1/2 tsp salt\n2 tbsp butter', 
'1. Mix dry ingredients in a large bowl\n2. Whisk wet ingredients separately\n3. Combine wet and dry ingredients until just mixed\n4. Cook on griddle until golden\n5. Serve with syrup and fresh fruits', 
10, 15, 4, 1, NULL),

('Rainbow Fruit Salad', 'Colorful and refreshing fruit mix',
'2 cups strawberries, sliced\n1 cup blueberries\n2 kiwis, peeled and sliced\n1 cup pineapple chunks\n2 oranges, segmented\n2 tbsp honey\n1 tbsp lime juice',
'1. Wash and prepare all fruits\n2. Combine in a large bowl\n3. Mix honey and lime juice\n4. Drizzle over fruits and toss gently\n5. Chill for 30 minutes before serving',
15, 0, 6, 1, NULL),

('Lemon Herb Grilled Chicken', 'Light and zesty grilled chicken',
'4 chicken breasts\n2 lemons, juiced\n3 cloves garlic, minced\n2 tbsp olive oil\n1 tbsp fresh thyme\n1 tbsp fresh rosemary\nSalt and pepper to taste',
'1. Marinate chicken in lemon juice, garlic, and herbs for 2 hours\n2. Preheat grill to medium-high\n3. Grill chicken 6-7 minutes per side\n4. Check internal temperature reaches 165°F\n5. Let rest 5 minutes before serving',
130, 15, 4, 1, NULL),

('Tropical Smoothie', 'Bright and energizing tropical blend',
'1 cup mango chunks\n1/2 cup pineapple\n1 banana\n1 cup coconut milk\n1 tbsp honey\n1/2 cup ice\nMint leaves for garnish',
'1. Add all fruits to blender\n2. Pour in coconut milk and honey\n3. Add ice and blend until smooth\n4. Taste and adjust sweetness\n5. Garnish with mint leaves',
5, 0, 2, 1, NULL),

('Garden Fresh Salad', 'Crisp vegetables with citrus dressing',
'4 cups mixed greens\n1 cucumber, sliced\n2 tomatoes, diced\n1/2 red onion, thinly sliced\n1/4 cup olive oil\n2 tbsp lemon juice\n1 tsp Dijon mustard\nSalt and pepper',
'1. Wash and dry all vegetables\n2. Combine vegetables in a large bowl\n3. Whisk together oil, lemon juice, and mustard\n4. Season dressing with salt and pepper\n5. Toss salad with dressing just before serving',
10, 0, 4, 1, NULL),

('Vanilla Berry Parfait', 'Layered yogurt and berry delight',
'2 cups Greek yogurt\n1/4 cup honey\n1 tsp vanilla extract\n1 cup granola\n1 cup mixed berries\n2 tbsp sliced almonds',
'1. Mix yogurt with honey and vanilla\n2. Layer yogurt mixture in glasses\n3. Add berries and granola\n4. Repeat layers\n5. Top with almonds and serve immediately',
10, 0, 4, 1, NULL),

('Citrus Glazed Salmon', 'Fresh and light salmon with citrus flavors',
'4 salmon fillets\n1/4 cup orange juice\n2 tbsp soy sauce\n2 tbsp honey\n1 tbsp ginger, grated\n2 cloves garlic, minced\n1 tbsp olive oil',
'1. Preheat oven to 400°F\n2. Mix orange juice, soy sauce, honey, ginger, and garlic\n3. Brush salmon with olive oil and glaze\n4. Bake for 12-15 minutes\n5. Brush with remaining glaze and serve',
10, 15, 4, 1, NULL),

-- Sad Mood Recipes (mood_id = 2)
('Chocolate Comfort Cake', 'Rich chocolate cake for those blue days',
'1 cup flour\n1/2 cup cocoa powder\n1 cup sugar\n1/2 cup butter\n2 eggs\n1 cup milk\n1 tsp vanilla\n1 tsp baking soda',
'1. Preheat oven to 350°F\n2. Mix dry ingredients in a bowl\n3. Cream butter and sugar, add eggs\n4. Alternate adding dry ingredients and milk\n5. Bake for 30-35 minutes\n6. Cool and frost if desired',
20, 35, 8, 2, NULL),

('Creamy Mac and Cheese', 'Ultimate comfort food with three cheeses',
'1 lb macaroni pasta\n4 tbsp butter\n4 tbsp flour\n2 cups milk\n2 cups cheddar cheese\n1 cup mozzarella\n1/2 cup parmesan\nSalt, pepper, paprika',
'1. Cook pasta according to package directions\n2. Make roux with butter and flour\n3. Gradually add milk, stirring constantly\n4. Add cheeses and melt\n5. Combine with pasta and bake at 350°F for 25 minutes',
20, 25, 6, 2, NULL),

('Chicken Noodle Soup', 'Classic comforting soup for the soul',
'1 whole chicken\n8 cups water\n3 carrots, sliced\n3 celery stalks, chopped\n1 onion, diced\n2 cups egg noodles\n2 bay leaves\nSalt, pepper, thyme',
'1. Boil chicken in water with vegetables and bay leaves\n2. Remove chicken and shred meat\n3. Strain broth and return to pot\n4. Add noodles and cook until tender\n5. Return chicken to pot and season',
30, 90, 8, 2, NULL),

('Warm Chocolate Brownies', 'Fudgy brownies perfect for comfort',
'1/2 cup butter\n1 cup chocolate chips\n2 eggs\n1 cup sugar\n1/2 cup flour\n1/4 cup cocoa powder\n1/2 tsp salt\n1 tsp vanilla',
'1. Preheat oven to 350°F\n2. Melt butter and chocolate chips\n3. Beat eggs and sugar until fluffy\n4. Mix in chocolate mixture and vanilla\n5. Fold in dry ingredients\n6. Bake 25-30 minutes',
15, 30, 12, 2, NULL),

('Beef Stew', 'Hearty and warming beef stew',
'2 lbs beef chuck, cubed\n4 potatoes, cubed\n3 carrots, sliced\n2 onions, chopped\n3 cups beef broth\n2 tbsp tomato paste\n2 tbsp flour\nSalt, pepper, thyme',
'1. Brown beef in large pot\n2. Add onions and cook until soft\n3. Add flour and tomato paste\n4. Add broth and vegetables\n5. Simmer 2 hours until tender',
20, 120, 6, 2, NULL),

('Grilled Cheese and Tomato Soup', 'Classic comfort food combination',
'8 slices bread\n4 slices cheddar cheese\n4 tbsp butter\n1 can tomato soup\n1/2 cup milk\nBasil for garnish',
'1. Butter one side of each bread slice\n2. Place cheese between unbuttered sides\n3. Grill until golden and cheese melts\n4. Heat soup with milk\n5. Serve together with fresh basil',
10, 15, 4, 2, NULL),

('Meatloaf with Mashed Potatoes', 'Traditional comfort meal',
'2 lbs ground beef\n1 onion, diced\n2 eggs\n1 cup breadcrumbs\n1/4 cup ketchup\n4 large potatoes\n1/2 cup milk\n4 tbsp butter\nSalt, pepper',
'1. Mix beef, onion, eggs, breadcrumbs for meatloaf\n2. Shape and bake at 350°F for 1 hour\n3. Boil potatoes until tender\n4. Mash with milk and butter\n5. Serve meatloaf over mashed potatoes',
25, 60, 6, 2, NULL),

-- Energetic Mood Recipes (mood_id = 3)
('Power Smoothie Bowl', 'Energizing breakfast packed with nutrients',
'1 banana\n1/2 cup berries\n1 scoop protein powder\n1/2 cup oats\n1 cup almond milk\nhoney\nGranola and nuts for topping',
'1. Blend banana, berries, protein powder, oats, and almond milk\n2. Pour into bowl\n3. Top with granola, nuts, and fresh fruits\n4. Drizzle with honey\n5. Enjoy immediately',
5, 0, 1, 3, NULL),

('Quinoa Energy Bowl', 'Protein-packed bowl for sustained energy',
'1 cup quinoa\n1 can black beans\n1 avocado, sliced\n1 cup corn\n2 tomatoes, diced\n1/4 cup cilantro\nLime juice and olive oil for dressing',
'1. Cook quinoa according to package directions\n2. Rinse and drain black beans\n3. Combine quinoa, beans, corn, tomatoes\n4. Top with avocado and cilantro\n5. Dress with lime juice and olive oil',
15, 15, 4, 3, NULL),

('Turkey and Spinach Wrap', 'High-protein wrap for on-the-go energy',
'4 whole wheat tortillas\n8 slices turkey breast\n2 cups fresh spinach\n1 avocado\n4 tbsp hummus\n1 cucumber, sliced\n1 bell pepper, sliced',
'1. Spread hummus on tortillas\n2. Layer turkey, spinach, and vegetables\n3. Add sliced avocado\n4. Roll tightly and secure with toothpick\n5. Cut in half and serve',
10, 0, 4, 3, NULL),

('Overnight Oats with Berries', 'Make-ahead breakfast for busy mornings',
'1 cup rolled oats\n1 cup milk\n2 tbsp chia seeds\n2 tbsp maple syrup\n1/2 cup mixed berries\n1/4 cup nuts\n1 tsp vanilla',
'1. Mix oats, milk, chia seeds, maple syrup, and vanilla\n2. Divide into jars\n3. Top with berries and nuts\n4. Refrigerate overnight\n5. Grab and go in the morning',
10, 0, 4, 3, NULL),

('Greek Chicken Pita', 'Mediterranean-inspired protein wrap',
'4 pita breads\n2 chicken breasts, grilled and sliced\n1 cucumber, diced\n2 tomatoes, diced\n1/2 red onion, sliced\n1/2 cup feta cheese\nTzatziki sauce',
'1. Grill chicken and slice thin\n2. Warm pita breads\n3. Fill with chicken and vegetables\n4. Add feta cheese\n5. Drizzle with tzatziki sauce',
15, 10, 4, 3, NULL),

('Protein Pancakes', 'High-protein pancakes for sustained energy',
'3 eggs\n1 banana, mashed\n1/2 cup oats\n1 scoop protein powder\n1 tsp baking powder\n1/4 cup milk\nBlueberries for topping',
'1. Blend all ingredients except blueberries\n2. Let batter rest 5 minutes\n3. Cook pancakes on medium heat\n4. Flip when bubbles form\n5. Top with fresh blueberries',
10, 10, 2, 3, NULL),

('Energy Balls', 'No-bake energy bites for quick fuel',
'1 cup dates, pitted\n1/2 cup almonds\n1/2 cup oats\n2 tbsp chia seeds\n2 tbsp coconut oil\n1 tsp vanilla\nCoconut flakes for rolling',
'1. Process dates until paste forms\n2. Add nuts and oats, pulse to combine\n3. Add chia seeds, oil, and vanilla\n4. Form into balls\n5. Roll in coconut flakes and chill',
15, 0, 12, 3, NULL),

-- Relaxed Mood Recipes (mood_id = 4)
('Herbal Tea Blend', 'Calming tea for peaceful moments',
'2 tsp chamomile\n1 tsp lavender\n1 tsp lemon balm\n2 cups hot water\nHoney to taste',
'1. Combine herbs in tea infuser\n2. Pour hot water over herbs\n3. Steep for 5-7 minutes\n4. Remove infuser\n5. Add honey to taste',
2, 7, 2, 4, NULL),

('Creamy Mushroom Risotto', 'Slow-cooked comfort rice dish',
'1 cup arborio rice\n4 cups warm vegetable broth\n1 lb mixed mushrooms\n1 onion, diced\n2 cloves garlic\n1/2 cup white wine\n1/2 cup parmesan\n2 tbsp butter',
'1. Sauté mushrooms and set aside\n2. Cook onion and garlic until soft\n3. Add rice and toast for 2 minutes\n4. Add wine, then broth gradually while stirring\n5. Fold in mushrooms, cheese, and butter',
15, 25, 4, 4, NULL),

('Lavender Honey Cookies', 'Delicate cookies with calming lavender',
'2 cups flour\n1/2 cup butter\n1/2 cup honey\n1 egg\n1 tsp dried lavender\n1/2 tsp vanilla\n1/4 tsp salt',
'1. Cream butter and honey\n2. Add egg and vanilla\n3. Mix in dry ingredients and lavender\n4. Chill dough 1 hour\n5. Bake at 350°F for 12-15 minutes',
75, 15, 24, 4, NULL),

('Gentle Vegetable Soup', 'Light and soothing vegetable broth',
'6 cups vegetable broth\n2 carrots, diced\n2 celery stalks, diced\n1 zucchini, diced\n1 cup spinach\n1 onion, diced\nFresh herbs',
'1. Sauté onion until translucent\n2. Add carrots and celery, cook 5 minutes\n3. Add broth and simmer 15 minutes\n4. Add zucchini and cook 5 more minutes\n5. Stir in spinach and herbs',
10, 25, 6, 4, NULL),

('Coconut Rice Pudding', 'Creamy and comforting dessert',
'1 cup jasmine rice\n2 cups coconut milk\n1/2 cup sugar\n1/4 tsp salt\n1 tsp vanilla\nCinnamon for dusting',
'1. Cook rice until tender\n2. Add coconut milk and sugar\n3. Simmer until creamy\n4. Stir in vanilla and salt\n5. Serve warm with cinnamon',
5, 30, 6, 4, NULL),

('Chamomile Poached Pears', 'Elegant and calming dessert',
'4 pears, peeled\n2 cups water\n1/2 cup sugar\n4 chamomile tea bags\n1 cinnamon stick\n2 cloves',
'1. Combine water, sugar, and spices in pot\n2. Add tea bags and steep 10 minutes\n3. Remove tea bags\n4. Poach pears in liquid 20 minutes\n5. Serve with poaching liquid',
15, 30, 4, 4, NULL),

('Soft Scrambled Eggs', 'Gentle and creamy breakfast',
'6 eggs\n2 tbsp cream\n2 tbsp butter\nSalt and pepper\nChives for garnish',
'1. Whisk eggs with cream gently\n2. Melt butter in non-stick pan over low heat\n3. Add eggs and stir constantly\n4. Cook slowly until just set\n5. Garnish with chives',
5, 8, 3, 4, NULL),

-- Romantic Mood Recipes (mood_id = 5)
('Chocolate Lava Cake', 'Decadent individual chocolate cakes',
'4 oz dark chocolate\n4 tbsp butter\n2 eggs\n2 tbsp sugar\n2 tbsp flour\nButter for ramekins\nPowdered sugar for dusting',
'1. Melt chocolate and butter together\n2. Whisk eggs and sugar until pale\n3. Fold in chocolate mixture and flour\n4. Pour into buttered ramekins\n5. Bake at 425°F for 12 minutes',
15, 12, 2, 5, NULL),

('Beef Wellington for Two', 'Elegant wrapped beef tenderloin',
'2 beef fillets\n1 sheet puff pastry\n4 oz mushroom duxelles\n2 slices prosciutto\n1 egg for wash\nSalt and pepper',
'1. Sear beef fillets and cool\n2. Wrap in prosciutto and mushrooms\n3. Encase in puff pastry\n4. Brush with egg wash\n5. Bake at 400°F for 25 minutes',
30, 25, 2, 5, NULL),

('Lobster Risotto', 'Luxurious seafood rice dish',
'2 lobster tails\n1 cup arborio rice\n4 cups seafood stock\n1/2 cup white wine\n1 shallot, minced\n2 tbsp butter\n1/4 cup cream',
'1. Cook lobster tails and remove meat\n2. Sauté shallot until soft\n3. Add rice and toast briefly\n4. Add wine, then stock gradually\n5. Fold in lobster meat, butter, and cream',
20, 30, 2, 5, NULL),

('Strawberry Champagne Flutes', 'Elegant sparkling cocktail',
'1 bottle champagne\n1 cup fresh strawberries\n2 tbsp sugar\n2 tbsp strawberry liqueur\nMint for garnish',
'1. Muddle strawberries with sugar\n2. Add strawberry liqueur\n3. Strain mixture into flutes\n4. Top with champagne\n5. Garnish with mint',
10, 0, 4, 5, NULL),

('Seared Scallops', 'Pan-seared scallops with cauliflower purée',
'12 large scallops\n1 cauliflower head\n1/2 cup cream\n2 tbsp butter\n2 tbsp olive oil\nSalt, pepper, chives',
'1. Make cauliflower purée with cream\n2. Pat scallops dry and season\n3. Sear in hot pan 2 minutes per side\n4. Plate over cauliflower purée\n5. Garnish with chives',
15, 10, 2, 5, NULL),

('Tiramisu for Two', 'Classic Italian dessert',
'12 ladyfingers\n1 cup strong coffee\n8 oz mascarpone\n2 egg yolks\n1/3 cup sugar\nCocoa powder for dusting',
'1. Whisk egg yolks and sugar until pale\n2. Fold in mascarpone\n3. Dip ladyfingers in coffee\n4. Layer with mascarpone mixture\n5. Chill 4 hours and dust with cocoa',
20, 0, 2, 5, NULL),

('Filet Mignon with Red Wine Sauce', 'Tender steaks with rich sauce',
'2 filet mignon steaks\n1 cup red wine\n2 shallots, minced\n2 tbsp butter\n1 tbsp olive oil\nSalt, pepper, thyme',
'1. Season steaks with salt and pepper\n2. Sear in hot pan with oil\n3. Cook to desired doneness\n4. Make sauce with wine and shallots\n5. Finish sauce with butter',
10, 15, 2, 5, NULL),

-- Stressed Mood Recipes (mood_id = 6)
('5-Minute Mug Cake', 'Quick chocolate fix in a mug',
'4 tbsp flour\n4 tbsp sugar\n2 tbsp cocoa powder\n3 tbsp milk\n3 tbsp oil\nPinch of salt',
'1. Mix dry ingredients in mug\n2. Add wet ingredients and stir\n3. Microwave 90 seconds\n4. Let cool 1 minute\n5. Enjoy straight from mug',
2, 2, 1, 6, NULL),

('Instant Ramen Upgrade', 'Quick comfort noodles with upgrades',
'1 package instant ramen\n1 egg\n1 green onion, sliced\n1 slice cheese\nSriracha to taste\nSesame oil',
'1. Cook ramen according to package\n2. Crack egg into hot broth\n3. Add cheese slice to melt\n4. Top with green onions\n5. Drizzle with sesame oil and sriracha',
2, 3, 1, 6, NULL),

('Microwave Baked Potato', 'Quick and filling comfort food',
'1 large potato\n2 tbsp butter\n1/4 cup cheese\n2 tbsp sour cream\nSalt, pepper, chives',
'1. Pierce potato with fork\n2. Microwave 8-10 minutes\n3. Cut open carefully\n4. Fluff with fork\n5. Top with butter, cheese, and sour cream',
2, 10, 1, 6, NULL),

('Peanut Butter Toast', 'Simple and satisfying snack',
'2 slices bread\n3 tbsp peanut butter\n1 banana, sliced\nHoney for drizzling\nCinnamon for sprinkling',
'1. Toast bread until golden\n2. Spread peanut butter generously\n3. Top with banana slices\n4. Drizzle with honey\n5. Sprinkle with cinnamon',
3, 2, 1, 6, NULL),

('Quick Quesadilla', 'Fast and cheesy comfort food',
'2 tortillas\n1 cup shredded cheese\n1/4 cup salsa\n2 tbsp sour cream\nOptional: leftover chicken or beans',
'1. Place cheese on one tortilla\n2. Add any optional fillings\n3. Top with second tortilla\n4. Cook in pan 2 minutes per side\n5. Cut and serve with salsa and sour cream',
3, 4, 1, 6, NULL),

('Cereal and Milk', 'Ultimate comfort breakfast any time',
'1 cup favorite cereal\n1 cup cold milk\nSliced banana or berries (optional)',
'1. Pour cereal into bowl\n2. Add cold milk\n3. Top with fresh fruit if desired\n4. Eat immediately\n5. Enjoy the simple comfort',
1, 0, 1, 6, NULL),

('Frozen Pizza Upgrade', 'Quick dinner with gourmet touches',
'1 frozen pizza\nExtra cheese\nFresh basil\nRed pepper flakes\nOlive oil for drizzling',
'1. Bake pizza according to package directions\n2. Add extra cheese in last 5 minutes\n3. Remove from oven\n4. Top with fresh basil\n5. Drizzle with olive oil and add red pepper flakes',
2, 15, 2, 6, NULL);
