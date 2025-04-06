import React from 'react';

const SearchBar = ({query, setQuery, onSearch }) => {

  const handleSearch = () => {
    if(!query) return;
    else if (query.trim() !== '') {
        onSearch(query.trim());
      }
  };

  return (
    <div className='search-container'>
      <input
        className='search-input'
        type="text"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Enter ingredients (e.g., egg, tomato, basil)"
        onKeyDown={(e) => e.key === "Enter" && handleSearch()}
      />
      <button className='search-button' onClick={handleSearch}>Search</button>
    </div>
  );
};

export default SearchBar;
