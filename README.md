# 🥘 Recipe Finder

A simple web app that helps users find recipes based on the ingredients they have at home — and how much time they have to cook. Built with **Ruby on Rails**, **React**, and **PostgreSQL**.

## ✨ Features

- 🔍 Search recipes by listing ingredients (e.g., `tomato, garlic, onion`)
- ⏱️ Optional filter by total cooking time (prep + cook)
- 📊 Results are ranked by how many distinct searched ingredients each recipe contains
- 🔄 "Load more" button to fetch additional results with pagination

## 🚀 Deployment
This application is deployed using Render, a cloud platform for web apps and databases.

### 🌐 Live App
You can check out the live version here: https://recipe-finder-x28y.onrender.com/

### ⚠️ Limitations of Free Render Plan
I'm currently using Render's free tier, which comes with a few limitations:

- **Cold Starts**: The server spins down after 15 minutes of inactivity, which causes a **delay** (10-30 seconds) on the **first** **request**.
  - During this time:
    You might see an "Application Error" or "Site can't be reached". The link may appear broken before finally working.
- **Database Wakeup**: Since I'm also using the free PostgreSQL database on Render, that **service** also goes to **sleep**. On the **first access**, the **web app may be ready before the database is**, causing timeouts or internal server errors on first access.
- **Limited Resources**: The free web service has restricted RAM and CPU, which can lead to slower performance under load.



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

### 2. Install Ruby using `asdf` (recommended)
This project uses Ruby 3.2.2 via asdf.
> **Note:** This guide assumes you're using macOS with Homebrew installed.  
> If you're on another system, check [asdf's docs](https://asdf-vm.com/) for platform-specific setup.


⬇️ Install `asdf` and required plugins
```bash
brew install asdf
echo '. "$(brew --prefix asdf)/libexec/asdf.sh"' >> ~/.zshrc
source ~/.zshrc

asdf plugin add ruby
asdf install ruby 3.2.2
asdf set local ruby 3.2.2

gem install bundler
asdf reshim ruby
```
> **Note:** Make sure your project path does not contain emojis or special characters — Ruby's native extensions may fail to compile.

### 3. Install PostgreSQL client (for `pg` gem)
```bash
brew install libpq
brew link --force libpq
```

### 4. Install dependencies
```bash 
    bundle install
    npm install
```

### 5. Set up the database and import recipes
```bash 
    rails db:create
    rails db:migrate
```

Then run the custom rake task to import recipes:
```bash 
    rails recipes:import
```

💡 This task reads from a JSON file (`db/seeds/recipes-en.json`) and populates the database with recipes and their ingredients.

### 6. Start the server 
```bash 
    bin/dev
```
