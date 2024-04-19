// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// ? https://firebase.google.com/docs/functions
// ? https://firebase.google.com/docs/functions/typescript

import * as admin from 'firebase-admin';
import {
  type CollectionReference, type DocumentData, Timestamp, type Query, type WriteBatch,
} from '@google-cloud/firestore';
import * as serviceAccount from '../serviceAccountKey-leka_alpha_dev.json';

const app = admin.initializeApp({
  credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
});

const database = admin.firestore();

async function deleteCollection(collection: CollectionReference, batchSize: number): Promise<void> {
  const collectionReference: CollectionReference = collection;
  const query: Query = collectionReference.orderBy('__name__').limit(batchSize);

  return new Promise((resolve, reject) => {
    deleteQueryBatch(query, resolve).catch(reject);
  });
}

async function deleteQueryBatch(query: Query, resolve: () => void): Promise<void> {
  const snapshot = await query.get();

  const batchSize = snapshot.size;
  if (batchSize === 0) {
    resolve();
    return;
  }

  const batch: WriteBatch = database.batch();

  for (const document of snapshot.docs) {
    batch.delete(document.ref);
  }

  await batch.commit();

  process.nextTick(() => {
    deleteQueryBatch(query, resolve);
  });
}

async function duplicateCollection(sourceCollection: CollectionReference, targetCollection: CollectionReference) {
  const snapshot = await sourceCollection.get();
  const writeBatch = database.batch();

  for (const document of snapshot) {
    const targetDocumentReference = targetCollection.doc(document.id);
    writeBatch.set(targetDocumentReference, document.data());
  }

  return writeBatch.commit().then(() => {
    console.log('Successfully duplicated collection from', sourceCollection, 'to', targetCollection);
  }).catch(error => {
    console.error('Failed to duplicate collection:', error);
  });
}

async function prepareCaregiversForMigration() {
  const database_ = admin.firestore();

  // ? get collections
  const oldCaregiversCollection = database_.collection('caregiver');
  const newCaregiversCollection = database_.collection('CAREGIVERS');

  let newCaregiversSnapshot = await newCaregiversCollection.get();

  // ? delete new collection if it exists
  if (!newCaregiversSnapshot.empty) {
    await deleteCollection(newCaregiversCollection, 500);
  }

  // ? duplicate old collection to new collection
  await duplicateCollection(oldCaregiversCollection, newCaregiversCollection);

  // ? prepare new caregivers collection
  newCaregiversSnapshot = await newCaregiversCollection.get();
  for (const document of newCaregiversSnapshot) {
    setCaregiverProperties(document);
  }

  console.log('Finished preparing all caregivers.');
}

async function setCaregiverProperties(document: DocumentData) {
  const dataCurrent = document.data();

  const dataNew = {
    is_leka_alpha_doc: true,
    uuid: document.id,
    root_owner_uid: dataCurrent.owner.id,
    created_at: Timestamp.now(),
    last_edited_at: Timestamp.now(),
    first_name: dataCurrent.firstname,
    last_name: dataCurrent.lastname,
    avatar: dataCurrent.image,
    birthdate: convertDateToFirestoreTimestamp(dataCurrent.birthdate),
    email: '',
    professions: [],
    color_scheme: 'light',
    color_theme: 'darkBlue',
  };

  console.info('current data:', dataCurrent);
  console.info('new data:    ', dataNew);

  await document.ref.set(dataNew);
}

async function prepareCareReceiversForMigration() {
  const database_ = admin.firestore();

  // ? get collections
  const oldCareReceiversCollection = database_.collection('patient');
  const newCareReceiversCollection = database_.collection('CARE_RECEIVERS');

  let newCareReceiversSnapshot = await newCareReceiversCollection.get();

  // ? delete new collection if it exists
  if (!newCareReceiversSnapshot.empty) {
    await deleteCollection(newCareReceiversCollection, 500);
  }

  // ? duplicate old collection to new collection
  await duplicateCollection(oldCareReceiversCollection, newCareReceiversCollection);

  // ? prepare new CareReceivers collection
  newCareReceiversSnapshot = await newCareReceiversCollection.get();
  for (const document of newCareReceiversSnapshot) {
    setCareReceiverProperties(document);
  }

  console.log('Finished preparing all care receivers.');
}

async function setCareReceiverProperties(document: DocumentData) {
  const dataCurrent = document.data();

  const dataNew = {
    is_leka_alpha_doc: true,
    uuid: document.id,
    root_owner_uid: dataCurrent.owner.id,
    created_at: Timestamp.now(),
    last_edited_at: Timestamp.now(),
    username: dataCurrent.firstname + ' ' + dataCurrent.lastname,
    avatar: dataCurrent.image,
    reinforcer: convertReinforcer(dataCurrent.reinforcer),
  };

  console.info('current data:', dataCurrent);
  console.info('new data:    ', dataNew);

  await document.ref.set(dataNew);
}

function convertDateToFirestoreTimestamp(dateString: string) {
  if (dateString === '') {
    return '';
  }

  const [day, month, year] = dateString.split('/').map(Number);
  const date = new Date(year, month - 1, day); // ? js date months are 0-indexed

  console.log(date); // Debug: Check the Date object
  console.log(date.getTime());

  return Timestamp.fromDate(date);
}

function convertReinforcer(id: number) {
  switch (id) {
    case 0x51: {
      return 'rainbow';
    }

    case 0x52: {
      return 'fire';
    }

    case 0x53: {
      return 'sprinkles';
    }

    case 0x54: {
      return 'spinBlinkBlueViolet';
    }

    case 0x55: {
      return 'spinBlinkGreenOff';
    }

    default: {
      return 'rainbow';
    }
  }
}

async function prepareRootAccountsForMigration() {
  const {users} = await admin.auth().listUsers();

  users.forEach(async user => {
    const rootAccountsCollection = database.collection('ROOT_ACCOUNTS');

    // ? if root account already exists, delete
    if (!(await rootAccountsCollection.get()).empty) {
      await deleteCollection(rootAccountsCollection, 500);
    }

    const newRootAccount = rootAccountsCollection.doc();
    const rootOwnerUid = user.uid;

    const data = {
      uuid: newRootAccount.id,
      root_owner_uid: rootOwnerUid,
      created_at: Timestamp.now(),
      last_edited_at: Timestamp.now(),
    };

    await newRootAccount.set(data);
  });
}

prepareCaregiversForMigration();
prepareCareReceiversForMigration();
prepareRootAccountsForMigration();
