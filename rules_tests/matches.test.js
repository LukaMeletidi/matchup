import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, it } from 'node:test';
import {
    assertFails,
    assertSucceeds,
    initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
    arrayRemove,
    arrayUnion,
    doc,
    setDoc,
    Timestamp,
    updateDoc,
} from 'firebase/firestore';

const [host, port] = (
    process.env.FIRESTORE_EMULATOR_HOST ?? '127.0.0.1:8080'
).split(':');

let testEnv;

before(async () => {
    testEnv = await initializeTestEnvironment({
        projectId: 'demo-matchup-matches',
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

async function seedMatch(overrides = {}) {
    await testEnv.withSecurityRulesDisabled(async (context) => {
        await setDoc(doc(context.firestore(), 'matches', 'match1'), {
            sportId: 'padel',
            organizerId: 'alice',
            venueName: 'Padel Stadium',
            startsAt: Timestamp.fromDate(new Date(Date.now() + 24 * 60 * 60 * 1000)),
            maxPlayers: 4,
            playerIds: ['alice'],
            createdAt: Timestamp.now(),
            ...overrides,
        });
    });
}

function matchRef(uid) {
    return doc(dbFor(uid), 'matches', 'match1');
}

describe('matches collection: join and leave', () => {
    it('lets a user join an open match', async () => {
        await seedMatch();
        await assertSucceeds(
            updateDoc(matchRef('bob'), { playerIds: arrayUnion('bob') }),
        );
    });

    it('does not let a user join a full match', async () => {
        await seedMatch({ playerIds: ['alice', 'u2', 'u3', 'u4'] });
        await assertFails(
            updateDoc(matchRef('bob'), { playerIds: arrayUnion('bob') }),
        );
    });

    it('does not let a user add someone else', async () => {
        await seedMatch();
        await assertFails(
            updateDoc(matchRef('bob'), { playerIds: arrayUnion('carol') }),
        );
    });

    it('lets a player leave a match', async () => {
        await seedMatch({ playerIds: ['alice', 'bob'] });
        await assertSucceeds(
            updateDoc(matchRef('bob'), { playerIds: arrayRemove('bob') }),
        );
    });

    it('does not let the organizer leave', async () => {
        await seedMatch();
        await assertFails(
            updateDoc(matchRef('alice'), { playerIds: arrayRemove('alice') }),
        );
    });

    it('does not let a user change other fields', async () => {
        await seedMatch();
        await assertFails(
            updateDoc(matchRef('bob'), { venueName: 'Hacked' }),
        );
    });
});

