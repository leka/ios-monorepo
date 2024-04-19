// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// ? https://firebase.google.com/docs/functions
// ? https://firebase.google.com/docs/functions/typescript

import * as admin from 'firebase-admin';
import {type CollectionReference} from '@google-cloud/firestore';
import * as serviceAccount from '../serviceAccountKey-leka_alpha_dev.json' assert { type: 'json' };

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
});

const listCollectionsAndDocuments = async () => {
  const database = admin.firestore();
  let collections: CollectionReference[];

  try {
    collections = await database.listCollections();
  } catch (error) {
    console.error('Error listing collections:', error);
    return;
  }

  for (const collection of collections) {
    const snapshot = await collection.listDocuments();
    console.info(`Collection ID: ${collection.id}`);
    for (const documentReference of snapshot) {
      const document = await documentReference.get();
      if (document.exists) {
        const data = document.data();
        if (data === undefined) {
          console.error(`Document ID: ${document.id}, no data`);
          continue;
        }

        if (data.firstname) {
          console.info(`doc_id: ${document.get('id')} - id: ${document.id} - firstname: ${data.firstname} - owner: ${data.owner.id}`);
        } else {
          console.error(`Document ID: ${document.id}, no firstname`);
        }
      }
    }
  }
};

await listCollectionsAndDocuments();
