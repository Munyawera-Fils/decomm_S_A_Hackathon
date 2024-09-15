import { writable } from 'svelte/store';

// Create a writable store to hold wallet addresses
export const walletAddresses = writable<string[]>([]);
