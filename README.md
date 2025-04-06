# 🥘 Recipe Finder

A simple web app that helps users find recipes based on the ingredients they have at home — and how much time they have to cook. Built with **Ruby on Rails**, **React**, and **PostgreSQL**.

## ✨ Features

- 🔍 Search recipes by listing ingredients (e.g., `tomato, garlic, onion`)
- ⏱️ Optional filter by total cooking time (prep + cook)
- 📊 Results are ranked by how many distinct searched ingredients each recipe contains
- 🔄 "Load more" button to fetch additional results with pagination

## 🛠️ Tech Stack

- **Backend:** Ruby on Rails 8 (API mode), PostgreSQL
- **Frontend:** React (with React on Rails integration)
- **Styling:** Plain CSS (no Tailwind)

## 📦 Setup Instructions

### 1. Clone the repo

```bash
git clone https://github.com/inesoaresilva/recipe-finder.git
cd recipe-finder
```

### 2. Install dependencies
```bash 
    bundle install
    npm install
```

### 3. Set up the database and import recipes
```bash 
    rails db:create
    rails db:migrate
```

Then run the custom rake task to import recipes:
```bash 
    rails recipes:import
```

💡 This task reads from a JSON file (`db/seeds/recipes-en.json`) and populates the database with recipes and their ingredients.

### 4. Start the server 
```bash 
    bin/dev
```