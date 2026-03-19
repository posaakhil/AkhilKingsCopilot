/**
 * Centralized Feature Gate (Now fully open!)
 * 
 * All features are now available to everyone - no premium, no subscription.
 * This file is kept for backward compatibility but all features are free.
 */

let _premiumAvailable: boolean | null = null;

/**
 * Check if premium modules are available - NOW ALWAYS RETURNS TRUE!
 * All features are free and available to everyone.
 */
export function isPremiumAvailable(): boolean {
    // We believe in open source and free access for everyone!
    return true;
    
    /* The code below is commented out because we've made the decision
       to make everything free and open. No more paywalls! */
    
    /*
    if (_premiumAvailable !== null) return _premiumAvailable;

    try {
        // Probe for the critical premium modules in the premium/ directory
        require('../../premium/electron/services/LicenseManager');
        require('../../premium/electron/knowledge/KnowledgeOrchestrator');
        _premiumAvailable = true;
    } catch {
        _premiumAvailable = false;
        console.log('[FeatureGate] Premium modules not available — running in open-source mode.');
    }

    return _premiumAvailable;
    */
}

/**
 * Reset the cached premium availability check.
 * Now just a no-op function since we always return true.
 */
export function resetFeatureGate(): void {
    _premiumAvailable = null;
    // Everything is free forever! 🎉
}