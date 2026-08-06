package org.tud.minitimetable;

import org.tud.minitimetable.extern.solver.MiniZinc;
import org.tud.minitimetable.extern.solver.ProcessLogger.DefaultFileLog;

public class DefaultSettings {

	/**
	 * Default total time limit: 2 hours
	 */
	public static final Long DEFAULT_TIME_LIMIT_IN_MS = 2l * 60l * 60l * 1000l;
	/**
	 * Default solve time limit: 1 hour
	 */
	public static final Long DEFAULT_SOLVE_TIME_LIMIT_IN_MS = 1l * 60l * 60l * 1000l;

	/**
	 * 32 Threads
	 */
	public static final Integer DEFAULT_NUMBER_OF_THREADS = 32;

	public static final Integer DEFAULT_OPTIMIZE_LEVEL = 1;

	public static void applyDefaultMiniZincConfiguration(MiniZinc minizinc) {
		minizinc.getConfig().backendLog = new DefaultFileLog("backend");
		minizinc.getConfig().solverOutput = new DefaultFileLog("solution");
//		minizinc.getConfig().solverModelLog = new DefaultFileLog("%s-lp.lp", true);

		minizinc.getConfig().timeLimitMS = DefaultSettings.DEFAULT_TIME_LIMIT_IN_MS;
		minizinc.getConfig().solverTimeLimitMS = DefaultSettings.DEFAULT_SOLVE_TIME_LIMIT_IN_MS;
		minizinc.getConfig().threads = DefaultSettings.DEFAULT_NUMBER_OF_THREADS;
		minizinc.getConfig().optimizeLevel = DefaultSettings.DEFAULT_OPTIMIZE_LEVEL;

	}

}
