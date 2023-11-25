import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import { TenantRoutes } from './routes/tenants.routes.js';
import { AuthRoutes } from './routes/auth.routes.js';

const PORT = process.env.PORT || 4444;

const app = express();
app.use(cors());

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Import Route
app.use('/api', TenantRoutes);
app.use('/api', AuthRoutes);

app.use('*', (req, res, next) => {
  res.status(400).send('Not allowed!')
})

app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});
