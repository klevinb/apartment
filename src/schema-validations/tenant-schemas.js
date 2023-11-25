import Joi from 'joi';

const tenantRegisterSchema = Joi.object({
  full_name: Joi.string().min(3).max(30).required(),
  email: Joi.string().email().required(),
  phone: Joi.string().min(5).max(20).required(),
  password: Joi.string().pattern(/^[a-zA-Z0-9]{3,30}$/).required()
});

const tenantLoginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().pattern(/^[a-zA-Z0-9]{3,30}$/).required()
});

export {
  tenantRegisterSchema,
  tenantLoginSchema
};
