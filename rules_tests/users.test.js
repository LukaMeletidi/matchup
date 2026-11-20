import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, it } from 'node:test';
import {
    assertFails,
    assertSucceeds,
    initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import { doc, getDoc, serverTimestamp, setDoc } from 'firebase/firestore';

const [host, port] = (
    process.env.FIRESTORE_EMULATOR_HOST ?? '127.0.0.1:8080'
).split(':');

let testEnv;

before(async () => {
    testEnv = await initializeTestEnvironment({
        projectId: 'demo-matchup',
        firestore: {
            host,
            port: Number(port),
            rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8'),
        },
    });
});

after(async () => {
    await testEnv.cleanup();
});

beforeEach(async () => {
    await testEnv.clearFirestore();
});

function dbFor(uid) {
    return testEnv.authenticatedContext(uid).firestore();
}

function validProfile() {
    return { nickname: 'Alice', createdAt: serverTimestamp() };
}

describe('users collection', () => {
    it('does not let a signed out user read a profile', async () => {
        const db = testEnv.unauthenticatedContext().firestore();
        await assertFails(getDoc(doc(db, 'users', 'alice')));
    });

    it('lets a signed in user read any profile', async () => {
        await assertSucceeds(getDoc(doc(dbFor('bob'), 'users', 'alice')));
    });

    it('lets a user create their own profile', async () => {
        await assertSucceeds(
            setDoc(doc(dbFor('alice'), 'users', 'alice'), validProfile()),
        );
    });

    it('does not let a user create a profile for someone else', async () => {
        await assertFails(
            setDoc(doc(dbFor('bob'), 'users', 'alice'), validProfile()),
        );
    });

    it('does not let a user save a too short nickname', async () => {
        await assertFails(
            setDoc(doc(dbFor('alice'), 'users', 'alice'), {
                ...validProfile(),
                nickname: 'ab',
            }),
        );
    });

    it('does not let a user add extra fields', async () => {
        await assertFails(
            setDoc(doc(dbFor('alice'), 'users', 'alice'), {
                ...validProfile(),
                isAdmin: true,
            }),
        );
    });
});