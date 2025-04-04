import React from 'react';

const SearchBar = ({query, setQuery, onSearch }) => {

  const handleSearch = () => {
    if(!query) return;
    else if (query.trim() !== '') {
        onSearch(query.trim());
      }
  };

  return (
    <div>
      <input
        type="text"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Search for recipes..."
        onKeyDown={(e) => e.key === "Enter" && handleSearch()}
      />
      <button onClick={handleSearch}>Search</button>
    </div>
  );
};

export default SearchBar;
