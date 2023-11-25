import 'dotenv/config.js';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { db } from '../../db-instance/db.js';
import { tenantRegisterSchema, tenantLoginSchema } from '../schema-validations/tenant-schemas.js';

export class TenantsController {
  async tenantLogin (req, res, next) {
    try {
      await tenantLoginSchema.validateAsync(req.body);
      const { email, password } = req.body;

      const tenant = await db.tenant.get(email);
      if (!tenant) return res.status(404).json({ message: "Tenant doesn't exists!" });

      const validPassword = await bcrypt.compare(password, tenant.password);
      if (!validPassword) return res.status(400).json({ message: 'Incorrect password' });

      const tokenSecret = process.env.TOKEN_SECRET;
      const refreshTokenSecret = process.env.REFRESH_TOKEN_SECRET;
      const tenantInfoForJwt = {
        tenant_id: tenant.tenant_id,
        email: tenant.email
      };

      const accessToken = jwt.sign(tenantInfoForJwt, tokenSecret, { expiresIn: '7d' });
      const refreshToken = jwt.sign(tenantInfoForJwt, refreshTokenSecret, { expiresIn: '20d' });

      delete tenant.password; // we should not send the password
      res
        .cookie('refreshToken', refreshToken, { httpOnly: true, sameSite: 'strict' })
        .header('Authorization', accessToken)
        .json({ tenant });
    } catch (error) {
      console.log(error);
      res.status(400).json(error?.details ? error.details : error);
    }
  }

  async tenantRegister (req, res, next) {
    try {
      await tenantRegisterSchema.validateAsync(req.body);
      const { full_name, email, phone, password } = req.body;
      const apartment = 'Brugata 8 HO401';

      const tenant = await db.tenant.get(email);

      if (!tenant) {
        const saltRounds = Number(process.env.SALT_ROUNDS);
        const hash = bcrypt.hashSync(password, saltRounds);
        const { tenant_id } = await db.tenant.add({
          full_name,
          apartment,
          email,
          phone,
          password: hash
        });
        return res.status(200).json({ tenant_id });
      }

      res.status(400).json({ message: 'Tenant already exists!' });
    } catch (error) {
      console.log(error);
      res.status(400).json(error?.details ? error.details : error);
    }
  }
};
