import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

export function initMotion() {
  const mm = gsap.matchMedia();

  // Official WiseWallet 2,000 ms 3-layer SVG logo reveal (click to replay)
  const logoStage = document.getElementById('hero-logo-stage');
  const walletLayer = document.getElementById('logo-layer-wallet');
  const cardLayer = document.getElementById('logo-layer-card');
  const markLayer = document.getElementById('logo-layer-mark');
  const masterLayer = document.getElementById('logo-layer-master');

  let logoTl = null;

  function buildLogoTimeline() {
    if (!walletLayer || !cardLayer || !markLayer || !masterLayer) return null;
    const tl = gsap.timeline();
    tl.set(walletLayer, { opacity: 0, scale: 0.96 })
      .set(cardLayer, { opacity: 0, yPercent: 10 })
      .set(markLayer, { opacity: 0 })
      .set(masterLayer, { opacity: 0 })
      .to(walletLayer, { opacity: 1, duration: 0.92, ease: 'power2.out' }, 0)
      .to(walletLayer, { scale: 1, duration: 1.56, ease: 'power3.out' }, 0)
      .to(cardLayer, { opacity: 1, yPercent: 0, duration: 1.0, ease: 'power3.out' }, 0.4)
      .to(markLayer, { opacity: 1, duration: 0.92, ease: 'power2.out' }, 0.84)
      .to(masterLayer, { opacity: 1, duration: 0.24, ease: 'power1.out' }, 1.76)
      .to([walletLayer, cardLayer, markLayer], { opacity: 0, duration: 0.2, ease: 'power1.out' }, 1.8);
    return tl;
  }

  mm.add('(prefers-reduced-motion: no-preference)', () => {
    // 1. Play 2s brand logo choreography
    logoTl = buildLogoTimeline();
    const onLogoClick = () => {
      logoTl?.restart();
    };
    logoStage?.addEventListener('click', onLogoClick);

    // 2. Scroll progress fallback only for browsers without CSS scroll-driven animations
    const supportsScrollTimeline =
      typeof CSS !== 'undefined' &&
      CSS.supports('animation-timeline: scroll()') &&
      CSS.supports('animation-range: 0% 100%');

    const progressEl = document.getElementById('scroll-progress');
    if (progressEl && !supportsScrollTimeline) {
      gsap.to(progressEl, {
        scaleX: 1,
        ease: 'none',
        scrollTrigger: {
          trigger: document.documentElement,
          start: 'top top',
          end: 'bottom bottom',
          scrub: true,
        },
      });
    }

    // 3. Staggered GPU-only section reveals (once: true prevents scroll-up flicker)
    document.querySelectorAll('.reveal-item').forEach((el) => {
      gsap.from(el, {
        y: 22,
        opacity: 0,
        duration: 0.55,
        ease: 'power2.out',
        clearProps: 'transform,opacity',
        scrollTrigger: {
          trigger: el,
          start: 'top 88%',
          once: true,
        },
      });
    });

    // 4. Subtle scroll-triggered SVG donut & trend line draw
    const trendPath = document.getElementById('trend-line-path');
    if (trendPath && typeof trendPath.getTotalLength === 'function') {
      const length = trendPath.getTotalLength();
      gsap.set(trendPath, { strokeDasharray: length, strokeDashoffset: length });
      gsap.to(trendPath, {
        strokeDashoffset: 0,
        duration: 1.05,
        ease: 'power2.out',
        scrollTrigger: {
          trigger: '#laporan',
          start: 'top 78%',
          once: true,
        },
      });
    }

    const donutSegs = document.querySelectorAll('.donut-seg');
    if (donutSegs.length) {
      gsap.from(donutSegs, {
        strokeDasharray: '0 289',
        duration: 0.9,
        stagger: 0.1,
        ease: 'power2.out',
        scrollTrigger: {
          trigger: '#laporan',
          start: 'top 78%',
          once: true,
        },
      });
    }

    // 5. Desktop fine-pointer micro-interactions: 3D phone tilt + 1 magnetic CTA
    const finePointer = window.matchMedia('(hover: hover) and (pointer: fine)').matches;
    const phoneCard = document.getElementById('hero-phone-card');
    const heroCta = document.getElementById('hero-primary-cta');

    let cleanupFinePointer = () => {};
    if (finePointer) {
      const cleanups = [];

      if (phoneCard) {
        const rx = gsap.quickTo(phoneCard, 'rotationX', { duration: 0.35, ease: 'power3.out' });
        const ry = gsap.quickTo(phoneCard, 'rotationY', { duration: 0.35, ease: 'power3.out' });

        const onMove = (e) => {
          const rect = phoneCard.getBoundingClientRect();
          const px = (e.clientX - rect.left) / rect.width - 0.5;
          const py = (e.clientY - rect.top) / rect.height - 0.5;
          ry(gsap.utils.clamp(-5, 5, px * 10));
          rx(gsap.utils.clamp(-5, 5, -py * 10));
        };
        const onLeave = () => {
          rx(0);
          ry(0);
        };
        phoneCard.addEventListener('pointermove', onMove);
        phoneCard.addEventListener('pointerleave', onLeave);
        cleanups.push(() => {
          phoneCard.removeEventListener('pointermove', onMove);
          phoneCard.removeEventListener('pointerleave', onLeave);
        });
      }

      if (heroCta) {
        const mx = gsap.quickTo(heroCta, 'x', { duration: 0.28, ease: 'power3.out' });
        const my = gsap.quickTo(heroCta, 'y', { duration: 0.28, ease: 'power3.out' });

        const onCtaMove = (e) => {
          const rect = heroCta.getBoundingClientRect();
          const dx = (e.clientX - (rect.left + rect.width / 2)) * 0.16;
          const dy = (e.clientY - (rect.top + rect.height / 2)) * 0.16;
          mx(gsap.utils.clamp(-8, 8, dx));
          my(gsap.utils.clamp(-6, 6, dy));
        };
        const onCtaLeave = () => {
          mx(0);
          my(0);
        };
        heroCta.addEventListener('pointermove', onCtaMove);
        heroCta.addEventListener('pointerleave', onCtaLeave);
        cleanups.push(() => {
          heroCta.removeEventListener('pointermove', onCtaMove);
          heroCta.removeEventListener('pointerleave', onCtaLeave);
        });
      }

      cleanupFinePointer = () => cleanups.forEach((fn) => fn());
    }

    // 6. Privacy flow highlight cycle (auto-pauses offscreen and on hidden tab)
    let activeStep = 0;
    let flowInterval = null;
    let isPrivacyVisible = false;

    const tickPrivacyStep = () => {
      const steps = document.querySelectorAll('#privacy-flow-steps .flow-step');
      if (!steps.length) return;
      activeStep = (activeStep + 1) % steps.length;
      steps.forEach((el, idx) => el.classList.toggle('is-active', idx === activeStep));
    };

    const updateFlowTimer = () => {
      const shouldRun = isPrivacyVisible && !document.hidden;
      if (shouldRun && !flowInterval) {
        flowInterval = window.setInterval(tickPrivacyStep, 2200);
      } else if (!shouldRun && flowInterval) {
        clearInterval(flowInterval);
        flowInterval = null;
      }
    };

    const privacySection = document.getElementById('privasi');
    let observer = null;
    if (privacySection && 'IntersectionObserver' in window) {
      observer = new IntersectionObserver(
        (entries) => {
          isPrivacyVisible = Boolean(entries[0]?.isIntersecting);
          updateFlowTimer();
        },
        { threshold: 0.2 },
      );
      observer.observe(privacySection);
    }
    document.addEventListener('visibilitychange', updateFlowTimer);

    return () => {
      logoStage?.removeEventListener('click', onLogoClick);
      logoTl?.kill();
      cleanupFinePointer();
      if (flowInterval) clearInterval(flowInterval);
      observer?.disconnect();
      document.removeEventListener('visibilitychange', updateFlowTimer);
    };
  });
}
