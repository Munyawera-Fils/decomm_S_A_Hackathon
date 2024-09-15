import { writable } from 'svelte/store';
import { AuthClient } from '@dfinity/auth-client';

// Store to hold the identity state
export const isAuthenticated = writable(false);
export const principal = writable(null);

/**
 * @type {AuthClient | null}
 */
let authClient = null;

// Initialize Auth Client
export async function initAuthClient() {
  authClient = await AuthClient.create();
  
  // Check if user is already authenticated
  const identity = authClient.getIdentity();
  if (identity) {
    isAuthenticated.set(!identity.getPrincipal().isAnonymous());
    // @ts-ignore
    principal.set(identity.getPrincipal().toText());
  }
}

// Login function
export async function login() {
  if (!authClient) {
    await initAuthClient();
  }

  // @ts-ignore
  await authClient.login({
    identityProvider: 'https://identity.ic0.app/#authorize',
    onSuccess: () => {
      isAuthenticated.set(true);
      // @ts-ignore
      principal.set(authClient.getIdentity().getPrincipal().toText());
    }
  });
}

// Logout function
export function logout() {
  authClient?.logout();
  isAuthenticated.set(false);
  principal.set(null);
}
