import React, { useState } from "react";
import SearchBar from "./SearchBar";

const App = () => {
    const [recipes, setRecipes] = useState([]); 
    const [query, setQuery] = useState(""); 
    const [start, setStart] = useState(0); 
    const [loading, setLoading] = useState(false);
    const [maxTime, setMaxTime] = useState("");


    const handleSearch = async (newQuery) => {
        setQuery(newQuery);  
        setRecipes([]);
        setStart(0);         
        fetchRecipes(newQuery, 0, true);  
    };

    const fetchRecipes = async (query, start, reset = false, limitTime = maxTime) => {
    
        try {
            setLoading(true);
            const params = new URLSearchParams();
            params.append("ingredients", query);
            params.append("start", start);
            if (limitTime) {
                params.append("max_time", limitTime);
            }

            console.log(params.toString());
            const response = await fetch(`/recipes/search?${params.toString()}`);

            if (!response.ok) throw new Error("Failed to fetch");

            const data = await response.json();

            const newRecipes = Object.values(data).flat();

            setRecipes((prevRecipes) => reset ? newRecipes : [...prevRecipes, ...newRecipes]);
        } catch (error) {
            console.error("Error fetching recipes:", error);
        } finally { 
            setLoading(false);
        } 
    };

    const loadMore = () => {
        const nextStart = start + 100;
        setStart(nextStart);
        fetchRecipes(query, nextStart); 
    };

    return (
        <div>
            <h1 className="title">👩‍🍳 What’s on the menu today? 🍝 </h1>
            <h2 className="subtitle">Find Your Recipe 🔍</h2>
            <SearchBar query={query} setQuery={setQuery} onSearch={handleSearch} placeholder={"Enter ingredients (e.g., egg,tomato,basil)"} />
            <div className="max-time-container">
                <label htmlFor="time-input">In a rush? Set a total cook + prep time ⏱️ (min): </label>
                <input
                    className="max-time-input"
                    id="time-input"
                    type="number"
                    value={maxTime}
                    onChange={(e) => setMaxTime(e.target.value)}
                    placeholder="e.g. 30"
                    min="1"
                />
            </div>

            {loading && <p className="loading">Loading recipes... 🍳</p>}
            
            {recipes?.map((recipe) => (
                <details key={recipe.id} className="recipe">
                    <summary className="recipe-title">
                    {recipe.title}
                    </summary>
                    <div className="recipe-description">
                        <p>
                        🧑‍🍳 <strong>Prep:</strong> {recipe.prep_time} min &nbsp;&nbsp;
                        🍲 <strong>Cook:</strong> {recipe.cook_time} min &nbsp;&nbsp;
                        ⏰ <strong>Total time:</strong> {recipe.cook_time + recipe.prep_time}  min
                        </p>
                        <p>Matched {recipe.match_count} times your searched ingredients </p>
                    </div>
               
                  <ul className="ingredients-list">
                    {recipe.ingredients.map((ingredient) => (
                      <li key={ingredient.id}>{ingredient.name}</li>
                    ))}
                  </ul>
                </details> ))}
            {recipes.length > 0 && (
                <button className="load-button" onClick={loadMore}>Load More</button>
            )}
        </div>
    );
};

export default App;
