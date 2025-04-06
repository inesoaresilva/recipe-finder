import React, { useState } from "react";
import SearchBar from "./SearchBar";

const App = () => {
    const [recipes, setRecipes] = useState([]); 
    const [query, setQuery] = useState(""); 
    const [start, setStart] = useState(0); 
    const [loading, setLoading] = useState(false);


    const handleSearch = async (newQuery) => {
        const normalizedQuery = newQuery.
        split(",").
        map((ingredient) => ingredient.trim().toLowerCase())
        .filter((i) => i.length > 0).
        join(",");

        setQuery(normalizedQuery);  
        setStart(0);         
        fetchRecipes(newQuery, 0, true);  
    };

    const fetchRecipes = async (query, start, reset = false) => {
        try {
            setLoading(true);
            const response = await fetch(`/recipes/search?ingredients=${encodeURIComponent(query)}&start=${start}`);
            if (!response.ok) throw new Error("Failed to fetch");

            const data = await response.json();

            const newRecipes = Object.values(data).flat();

            console.log("Fetched recipes:", newRecipes);

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
            <SearchBar query={query} setQuery={setQuery} onSearch={handleSearch} />
            {loading && <p className="loading">Loading recipes... 🍳</p>}
            <ul>
                {recipes.map((recipe) => (
                    <li key={recipe.id}>
                        <h2>{recipe.title}</h2>
                    </li>
                ))}
            </ul>

            {recipes.length > 0 && (
                <button onClick={loadMore}>Load More</button>
            )}
        </div>
    );
};

export default App;
