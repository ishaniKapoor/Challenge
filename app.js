const express = require('express');
const { Pool } = require('pg');
const path = require('path');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

app.use(express.static(path.join('')));
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '', 'webpage.html'));
});

const pool = new Pool({
    user: 'postgres',
    database: 'krikeydata',
    password: 'new_password', 
    port: 5432, 
});

app.get('/author_name', (req, res) => {
    const query = 'SELECT a.name, a.email, s.item_price*s.quantity as revenue FROM sale_items s join books b on b.id = s.book_id join authors a on a.id = b.author_id group by a.name, a.email, revenue order by revenue DESC;';
  
    pool.query(query, (error, result) => {
      if (error) {
        console.error('Error occurred:', error);
        res.status(500).send('An error occurred while retrieving data from the database.');
      } else {
        const authors = result.rows;
        res.json(authors);
      }
    });
});

app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});