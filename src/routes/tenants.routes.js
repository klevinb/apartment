import { Router } from 'express';
import { TenantsController } from '../controllers/tenants.controllers.js';
import { verifyToken } from '../middleware/auth.middleware.js';

const router = Router();
const tenantController = new TenantsController();

router.post('/login', tenantController.tenantLogin);
router.post('/register', tenantController.tenantRegister);

router.get('/protected', verifyToken, (req, res) => {
  res.json({ message: 'Protected route accessed', tenant: req.tenant });
});

export { router as TenantRoutes };
