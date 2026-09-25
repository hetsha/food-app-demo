const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');

async function main() {
  const prisma = new PrismaClient();
  const passwordHash = await bcrypt.hash('admin123', 10);

  const admin = await prisma.user.upsert({
    where: { email: 'admin@parabdi.com' },
    update: {},
    create: {
      id: crypto.randomUUID(),
      phoneNumber: '+919999999999',
      email: 'admin@parabdi.com',
      fullName: 'Admin',
      role: 'admin',
      passwordHash: passwordHash,
    },
  });

  console.log('Admin user created:', admin.email);
  await prisma.$disconnect();
}

main().catch((e) => { console.error(e); process.exit(1); });
