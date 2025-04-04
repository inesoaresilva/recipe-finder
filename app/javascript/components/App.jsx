import React, { useState } from "react";
import SearchBar from "./SearchBar";

const App = () => {
    const [recipes, setRecipes] = useState([]); 
    const [query, setQuery] = useState(""); 
    const [start, setStart] = useState(0); 

    const handleSearch = async (newQuery) => {
        if (!newQuery.trim()) return;

        setQuery(newQuery);  
        setStart(0);         
        fetchRecipes(newQuery, 0, true);  
    };

    const fetchRecipes = async (query, start, reset = false) => {
        try {
            const response = await fetch(`/recipes/search?query=${encodeURIComponent(query)}&start=${start}`);
            if (!response.ok) throw new Error("Failed to fetch");

            const data = await response.json();

            const newRecipes = Object.values(data).flat();

            setRecipes((prevRecipes) => reset ? newRecipes : [...prevRecipes, ...newRecipes]);
        } catch (error) {
            console.error("Error fetching recipes:", error);
        }
    };

    const loadMore = () => {
        const nextStart = start + 100;
        setStart(nextStart);
        fetchRecipes(query, nextStart); 
    };

    return (
        <div>
            <h1>Recipe Finder</h1>
            <SearchBar query={query} setQuery={setQuery} onSearch={handleSearch} />
            
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
