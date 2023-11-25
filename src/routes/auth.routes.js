import { Router } from 'express';
import jwt from 'jsonwebtoken';

const router = Router();

router.post('/renew-token', (req, res) => {
  const refreshToken = req.headers.cookie?.replace('refreshToken=', '');
  if (!refreshToken) {
    return res.status(401).send('Access Denied. No refresh token provided.');
  }

  try {
    const decoded = jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET, (err, decoded) => {
      if (err) return res.status(401).json({ message: 'Token invalid or expired' });
      return decoded;
    });
    const accessToken = jwt.sign(
      {
        tenant: decoded.tenant_id,
        email: decoded.email
      }
      ,
      process.env.TOKEN_SECRET,
      { expiresIn: '7d' }
    );

    res
      .header('Authorization', accessToken)
      .send({ message: 'Refresh token generated!' });
  } catch (error) {
    return res.status(400).send('Invalid refresh token.');
  }
});

export { router as AuthRoutes };
