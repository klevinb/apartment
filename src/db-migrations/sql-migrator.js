import { spawn } from 'child_process';
import 'dotenv/config'

const run = async () => {
  const connectionConf = process.env.DB_CONNECTION_STRING;
  const migrationsPath = './src/db-migrations/migrations';
  const command = `npx migrator --db='${connectionConf}' --dir='${migrationsPath}'`;

  const child = spawn(command, ['--color=always'], { shell: true });
  child.stdout.on('data', (data) => console.log(data.toString()));
  child.stderr.on('data', (data) => console.error(data.toString()));
  child.on('exit', (code) => process.exit(code));
};

run().then();
