import React from 'react';

const SearchBar = ({query, setQuery, onSearch, placeholder }) => {

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
        placeholder={placeholder}
        onKeyDown={(e) => e.key === "Enter" && handleSearch()}
      />
      <button className='search-button' onClick={handleSearch}>Search</button>
    </div>
  );
};

export default SearchBar;
