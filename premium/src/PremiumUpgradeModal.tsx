import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Lock, Key, ExternalLink, CheckCircle, AlertCircle, Copy, Check, X, Sparkles } from 'lucide-react';

interface PremiumUpgradeModalProps {
    isOpen: boolean;
    onClose: () => void;
    onActivated: () => void;
    onDeactivated?: () => void;
    isPremium?: boolean;
}

/**
 * Premium Upgrade Modal — Shown when non-premium users try to access Profile/JD features.
 * Provides Gumroad purchase link, license key input, and hardware ID display.
 *
 * ⚠️  PRIVATE FILE — Do NOT commit to the public/OSS repository.
 */
export const PremiumUpgradeModal: React.FC<PremiumUpgradeModalProps> = ({ isOpen, onClose, onActivated, onDeactivated }) => {
    const [licenseKey, setLicenseKey] = useState('');
    const [hardwareId, setHardwareId] = useState('');
    const [status, setStatus] = useState<'idle' | 'loading' | 'success' | 'error'>('idle');
    const [errorMessage, setErrorMessage] = useState('');
    const [copiedHwid, setCopiedHwid] = useState(false);

    useEffect(() => {
        if (isOpen) {
            window.electronAPI?.licenseGetHardwareId?.().then(setHardwareId).catch(() => setHardwareId('unavailable'));
            setStatus('idle');
            setErrorMessage('');
            setLicenseKey('');
        }
    }, [isOpen]);

    const handleActivate = async () => {
        if (!licenseKey.trim()) return;
        setStatus('loading');
        setErrorMessage('');

        try {
            const result = await window.electronAPI?.licenseActivate?.(licenseKey.trim());
            if (result?.success) {
                setStatus('success');
                setTimeout(() => {
                    onActivated();
                    onClose();
                }, 1200);
            } else {
                setStatus('error');
                setErrorMessage(result?.error || 'Activation failed. Please try again.');
            }
        } catch (e: any) {
            setStatus('error');
            setErrorMessage(e.message || 'Activation failed.');
        }
    };

    const handleDeactivate = async () => {
        try {
            await window.electronAPI?.licenseDeactivate?.();
            onDeactivated?.();
            onClose();
        } catch (e: any) {
            setErrorMessage(e.message || 'Deactivation failed.');
        }
    };

    const copyHardwareId = () => {
        navigator.clipboard.writeText(hardwareId);
        setCopiedHwid(true);
        setTimeout(() => setCopiedHwid(false), 2000);
    };

    const handleUseCopilotFree = () => {
        onClose();
    };

    return (
        <AnimatePresence>
        {isOpen && (
        <motion.div 
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.2, ease: [0.4, 0, 0.2, 1] }}
            className="fixed inset-0 z-[200] flex items-center justify-center" 
            onClick={onClose}
        >
            {/* Backdrop */}
            <div className="absolute inset-0 bg-black/40 backdrop-blur-[2px]" />

            {/* Modal */}
            <motion.div
                initial={{ opacity: 0, scale: 0.92, y: 12 }}
                animate={{ opacity: 1, scale: 1, y: 0 }}
                exit={{ opacity: 0, scale: 0.95, y: 6 }}
                transition={{ 
                    type: "spring", 
                    stiffness: 380, 
                    damping: 30, 
                    mass: 0.8,
                    delay: 0.05 
                }}
                className="relative w-[380px] bg-[#111111] border border-white/[0.06] rounded-2xl shadow-[0_20px_60px_rgba(0,0,0,0.6),inset_0_1px_0_rgba(255,255,255,0.05)] overflow-hidden"
                onClick={(e) => e.stopPropagation()}
            >

                {/* Close button */}
                <button
                    onClick={onClose}
                    className="absolute top-4 right-4 text-text-tertiary hover:text-text-primary transition-colors z-10"
                >
                    <X size={16} />
                </button>

                {/* Content */}
                <div className="p-6">
                    {/* Header */}
                    <div className="flex flex-col items-center text-center gap-3 mb-6">
                        <div className="w-16 h-16 rounded-[16px] bg-white/[0.03] border border-white/[0.05] flex items-center justify-center shadow-inner relative group transition-transform duration-500 hover:scale-105">
                            <Sparkles size={28} className="text-white/70" strokeWidth={2} />
                        </div>
                        <div>
                            <h2 className="text-[20px] font-semibold text-white/90 tracking-tight">AkhilCopilot FREE</h2>
                            <p className="text-[12px] text-white/40 mt-1 max-w-[260px] mx-auto leading-relaxed">Made by Akhil • Completely Free</p>
                        </div>
                    </div>

                    {/* Feature list */}
                    <div className="mt-5 space-y-2 bg-white/[0.02] border border-white/[0.04] rounded-xl p-4">
                        {[
                            'Professional Identity Graph',
                            'JD analysis & persona tuning',
                            'Company research & salaries',
                            'Mock interviews & gap analysis'
                        ].map((feature, i) => (
                            <div key={i} className="flex items-center gap-2.5">
                                <div className="w-[14px] h-[14px] rounded-[4px] bg-white/[0.05] border border-white/[0.05] flex items-center justify-center shrink-0">
                                    <Check size={8} className="text-white/60" strokeWidth={3} />
                                </div>
                                <span className="text-[12px] text-white/60">{feature}</span>
                            </div>
                        ))}
                    </div>

                    {/* Free badge */}
                    <div className="mt-4 flex justify-center">
                        <div className="px-3 py-1 rounded-full bg-white text-black text-[10px] font-black tracking-tighter">
                            FULLY FREE
                        </div>
                    </div>

                    {/* Use Copilot Free button */}
                    <button
                        onClick={handleUseCopilotFree}
                        className="mt-5 w-full py-3 rounded-[10px] bg-white text-black text-[13px] font-semibold hover:bg-white/90 active:scale-[0.98] transition-all duration-200 flex items-center justify-center gap-2 shadow-[0_0_15px_rgba(255,255,255,0.15)] hover:shadow-[0_0_20px_rgba(255,255,255,0.25)]"
                    >
                        <Sparkles size={14} /> Use Copilot Free
                    </button>

                    <p className="text-[10px] text-white/30 text-center px-4 mt-4 leading-relaxed">
                        All premium features are now completely free, made by Akhil.
                    </p>

                    {/* Hardware ID */}
                    {hardwareId && (
                        <div className="mt-4 pt-3 border-t border-white/[0.04]">
                            <div className="flex items-center justify-between">
                                <span className="text-[9px] text-white/30 uppercase tracking-widest font-medium">Device ID</span>
                                <button
                                    onClick={copyHardwareId}
                                    className="text-[9px] text-white/30 hover:text-white/60 transition-colors flex items-center gap-1"
                                >
                                    {copiedHwid ? <Check size={8} className="text-green-400" /> : <Copy size={8} />}
                                    {copiedHwid ? 'Copied' : 'Copy'}
                                </button>
                            </div>
                            <p className="text-[9px] text-white/20 font-mono mt-1 truncate select-all">
                                {hardwareId}
                            </p>
                        </div>
                    )}
                </div>
            </motion.div>
        </motion.div>
        )}
        </AnimatePresence>
    );
};

export default PremiumUpgradeModal;